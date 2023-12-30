-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ProjectProposal" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT,
    "execAgencyId" TEXT NOT NULL,
    "assignedId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "latitude" REAL NOT NULL,
    "longitude" REAL NOT NULL,
    "cost" REAL NOT NULL,
    "timespan" REAL NOT NULL,
    "goal" TEXT NOT NULL,
    "proposalDate" DATETIME NOT NULL,
    CONSTRAINT "ProjectProposal_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "ProjectProposal_execAgencyId_fkey" FOREIGN KEY ("execAgencyId") REFERENCES "Agency" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_ProjectProposal" ("assignedId", "cost", "execAgencyId", "goal", "id", "latitude", "location", "longitude", "name", "proposalDate", "timespan", "userId") SELECT "assignedId", "cost", "execAgencyId", "goal", "id", "latitude", "location", "longitude", "name", "proposalDate", "timespan", "userId" FROM "ProjectProposal";
DROP TABLE "ProjectProposal";
ALTER TABLE "new_ProjectProposal" RENAME TO "ProjectProposal";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
