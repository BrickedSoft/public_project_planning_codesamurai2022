import { PrismaClient, Prisma } from '@prisma/client'
import prisma from '../lib/db'
import csv from 'csvtojson';
import { connect } from 'http2';


const loadFromAgencies = async (clearTable = false) => {
  // clear all existing data
  if (clearTable)
    await prisma.agency.deleteMany();

  // parse agency list from csv
  const data = await csv().fromFile('./agencies.csv');

  // seeding data into database
  for (const item of data) {
    const createdRecord = await prisma.agency.create({
      data: item
    });
    console.log("Agency: ", createdRecord)
  }

}
const loadFromUserTypes = async (clearTable = false) => {
  if (clearTable)
    await prisma.userType.deleteMany();
  const data = await csv().fromFile('./user_types.csv');

  for (const item of data) {
    const createdRecord = await prisma.userType.create({
      data: item
    });
    console.log("userType: ", createdRecord)
  }
}
const loadFromConstraints = async (clearTable = false) => {
  if (clearTable)
    await prisma.constaints.deleteMany();
  const data = await csv().fromFile('./constraints.csv');

  for (const item of data) {
    const createdRecord = await prisma.constaints.create({
      data: {
        code: item.code,
        maxLimit: parseInt(item.max_limit),
        constraintType: item.constraint_type
      }
    });
    console.log("constraint: ", createdRecord)
  }
}
const loadFromProposals = async (clearTable = false) => {
  if (clearTable)
    await prisma.projectProposal.deleteMany();
  const data = await csv().fromFile('./proposals.csv');

  for (const item of data) {
    const agency = await prisma.agency.findUniqueOrThrow({
      where: {
        code: item.exec
      }
    })

    if (agency != null) {
      console.log(item.proposal_date)
      const createdRecord = await prisma.projectProposal.create({
        data: {
          name: item.name,
          location: item.location,
          latitude: parseFloat(item.latitude),
          longitude: parseFloat(item.longitude),
          execAgency: {
            connect: { id: agency.id }
          },
          cost: parseFloat(item.cost),
          timespan: parseFloat(item.timespan),
          assignedId: item.project_id,
          goal: item.goal,
          proposalDate: new Date(item.proposal_date)
        },
        include: {
          execAgency: true
        }
      });
      console.log("proposal: ", createdRecord)
    }

  }
}
const loadFromProjects = async (clearTable = false) => {
  if (clearTable)
    await prisma.project.deleteMany();
  const data = await csv().fromFile('./projects.csv');

  for (const item of data) {
    const agency = await prisma.agency.findUniqueOrThrow({
      where: {
        code: item.exec
      }
    })
    const projectProposal = await prisma.projectProposal.create({
      data: {
        name: item.name,
        location: item.location,
        latitude: parseFloat(item.latitude),
        longitude: parseFloat(item.longitude),
        execAgency: {
          connect: { id: agency.id }
        },
        cost: parseFloat(item.cost),
        timespan: parseFloat(item.timespan),
        assignedId: item.project_id,
        goal: item.goal,
        proposalDate: new Date(item.start_date)
      }
    })
    const createdRecord = await prisma.project.create({
      data: {
        startDate: new Date(item.start_date),
        completion: parseFloat(item.completion),
        actualCost: parseFloat(item.actual_cost),
        projectProposal: {
          connect: {
            id: projectProposal.id
          }
        }
      }, include: {
        projectProposal: true
      }
    });
    console.log("project: ", createdRecord)
  }
}

const loadFromComponents = async (clearTable = false) => {
  if (clearTable)
    await prisma.projectProposalComponent.deleteMany();
  const data = await csv().fromFile('./components.csv');

  for (const item of data) {
    console.log(item.project_id)
    const projectProposal = await prisma.projectProposal.findFirstOrThrow({
      where: {
        assignedId: item.project_id
      }
    })
    const createdRecord = await prisma.projectProposalComponent.create({
      data: {
        assignedId: item.component_id,
        type: item.component_type,
        budgetRatio: parseFloat(item["budget ratio"]),
        projectProposal: {
          connect: { id: projectProposal.id }
        },
      },
      include: {
        ancestor: true,
        projectProposal: true,
        decendents: true
      }
    });
    console.log("component: ", createdRecord)
  }


  for (const item of data) {
    if (item.depends_on) {
      console.log(item.depends_on)
      const ancestor = await prisma.projectProposalComponent.findFirstOrThrow({
        where: {
          assignedId: item.depends_on
        }
      })
      if (ancestor == null) {
        console.log("no ancestor found")
        continue
      }
      const update = await prisma.projectProposalComponent.updateMany({
        where: {
          assignedId: item.component_id
        },
        data: {
          ancestorId: ancestor.id
        }

      })
      console.log("update for ancestor:", update)
    }
  }
}


async function main() {
  await loadFromAgencies(true)
  await loadFromUserTypes(true)
  await loadFromConstraints(true)
  await loadFromProposals(true)
  await loadFromProjects(true)
  await loadFromComponents(true)

}

main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })


