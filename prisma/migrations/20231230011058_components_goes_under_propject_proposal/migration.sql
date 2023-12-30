/*
  Warnings:

  - You are about to drop the `ProjectComponent` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "ProjectComponent";
PRAGMA foreign_keys=on;

-- CreateTable
CREATE TABLE "ProjectProposalComponent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "projectProposalId" TEXT NOT NULL,
    "ancestorId" TEXT,
    "assignedId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "budgetRatio" REAL NOT NULL,
    CONSTRAINT "ProjectProposalComponent_projectProposalId_fkey" FOREIGN KEY ("projectProposalId") REFERENCES "ProjectProposal" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ProjectProposalComponent_ancestorId_fkey" FOREIGN KEY ("ancestorId") REFERENCES "ProjectProposalComponent" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
