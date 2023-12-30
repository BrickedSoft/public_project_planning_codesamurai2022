/*
  Warnings:

  - You are about to drop the column `parentId` on the `ProjectComponent` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ProjectComponent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "projectId" TEXT NOT NULL,
    "ancestorId" TEXT,
    "assignedId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "budgetRatio" REAL NOT NULL,
    CONSTRAINT "ProjectComponent_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ProjectComponent_ancestorId_fkey" FOREIGN KEY ("ancestorId") REFERENCES "ProjectComponent" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_ProjectComponent" ("assignedId", "budgetRatio", "id", "projectId", "type") SELECT "assignedId", "budgetRatio", "id", "projectId", "type" FROM "ProjectComponent";
DROP TABLE "ProjectComponent";
ALTER TABLE "new_ProjectComponent" RENAME TO "ProjectComponent";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
