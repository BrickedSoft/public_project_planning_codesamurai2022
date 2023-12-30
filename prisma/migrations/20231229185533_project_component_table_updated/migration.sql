/*
  Warnings:

  - You are about to drop the column `actualCost` on the `ProjectComponent` table. All the data in the column will be lost.
  - You are about to drop the column `startDate` on the `ProjectComponent` table. All the data in the column will be lost.
  - Added the required column `budgetRatio` to the `ProjectComponent` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ProjectComponent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "projectId" TEXT NOT NULL,
    "parentId" TEXT NOT NULL,
    "assignedId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "completion" REAL NOT NULL,
    "budgetRatio" REAL NOT NULL,
    CONSTRAINT "ProjectComponent_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ProjectComponent_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "ProjectComponent" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_ProjectComponent" ("assignedId", "completion", "id", "parentId", "projectId", "type") SELECT "assignedId", "completion", "id", "parentId", "projectId", "type" FROM "ProjectComponent";
DROP TABLE "ProjectComponent";
ALTER TABLE "new_ProjectComponent" RENAME TO "ProjectComponent";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
