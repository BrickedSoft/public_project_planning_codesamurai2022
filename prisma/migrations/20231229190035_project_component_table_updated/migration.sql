-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ProjectComponent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "projectId" TEXT NOT NULL,
    "parentId" TEXT,
    "assignedId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "budgetRatio" REAL NOT NULL,
    CONSTRAINT "ProjectComponent_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ProjectComponent_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "ProjectComponent" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_ProjectComponent" ("assignedId", "budgetRatio", "id", "parentId", "projectId", "type") SELECT "assignedId", "budgetRatio", "id", "parentId", "projectId", "type" FROM "ProjectComponent";
DROP TABLE "ProjectComponent";
ALTER TABLE "new_ProjectComponent" RENAME TO "ProjectComponent";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
