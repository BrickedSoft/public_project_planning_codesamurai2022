/*
  Warnings:

  - A unique constraint covering the columns `[assignedId]` on the table `ProjectProposal` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "ProjectProposal_assignedId_key" ON "ProjectProposal"("assignedId");
