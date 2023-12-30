/*
  Warnings:

  - Added the required column `actualCost` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `completion` to the `Project` table without a default value. This is not possible if the table is not empty.
  - Added the required column `startDate` to the `Project` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Project" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "projectProposalId" TEXT NOT NULL,
    "startDate" DATETIME NOT NULL,
    "completion" REAL NOT NULL,
    "actualCost" REAL NOT NULL,
    CONSTRAINT "Project_projectProposalId_fkey" FOREIGN KEY ("projectProposalId") REFERENCES "ProjectProposal" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Project" ("id", "projectProposalId") SELECT "id", "projectProposalId" FROM "Project";
DROP TABLE "Project";
ALTER TABLE "new_Project" RENAME TO "Project";
CREATE UNIQUE INDEX "Project_projectProposalId_key" ON "Project"("projectProposalId");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
