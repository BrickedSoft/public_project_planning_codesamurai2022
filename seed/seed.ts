import { PrismaClient, Prisma } from '@prisma/client'
import prisma from '../lib/db'

async function main() {
  const userType = await prisma.userType.create({
    data: {
      code: "sadf",
      committee: "sadgf",
      description: "Sddf",
    },
  })
  console.log(userType)
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