# Setup — Install and Restore AdventureWorks

This guide explains how to download Microsoft's **AdventureWorks** sample
database and restore it on a local SQL Server instance, so you can run the
queries in this repository.

AdventureWorks simulates *Adventure Works Cycles*, a fictional company that
manufactures and sells bicycles and accessories. Its schema (sales, production,
HR, purchasing) is rich enough to practice everything from basic queries to
optimization.

---

## Prerequisites

| Tool | Notes |
|---|---|
| **SQL Server** | The Developer or Express edition (both free) will do. |
| **SQL Server Management Studio (SSMS)** | To restore through a graphical interface. |

> AdventureWorks is compatible with SQL Server 2012 and later.

---

## Step 1 · Download the `.bak` file

Download the backup from Microsoft's official *releases* page:

- **Downloads page:** https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks
- **Official documentation:** https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure

In the *OLTP backups* section, pick the version that matches (or is older than)
your SQL Server. For example, download **`AdventureWorks2022.bak`** if you use
SQL Server 2022.

> **Available variants:**
> - `AdventureWorks` (OLTP) — the transactional one. **This is the one this repository uses.**
> - `AdventureWorksDW` — geared toward *data warehousing* (dimensional model).
> - `AdventureWorksLT` — a lightweight, reduced version.

Example direct link:
`https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak`

---

## Step 2 · Move the `.bak` to the backup folder

Move the downloaded file to your instance's *Backup* folder, where SQL Server is
guaranteed to have read permissions. If you leave it in *Downloads* or on the
*Desktop*, the restore often fails due to permissions.

The default path depends on your SQL Server version:

| Version | Default Backup folder |
|---|---|
| SQL Server 2019 | `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\` |
| SQL Server 2022 | `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\` |
| SQL Server 2025 | `C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Backup\` |

> The number after `MSSQL` changes with the version (15 = 2019, 16 = 2022, 17 = 2025).
> If you use a named instance, replace `MSSQLSERVER` with your instance name.

---

## Step 3 · Restore the database

You can restore in two ways. The graphical interface (3A) is the simplest; the
T-SQL route (3B) is reproducible and leaves you with a script.

### Option 3A · Restore with SSMS (graphical interface)

1. Open **SQL Server Management Studio** and connect to your instance
   (usually `localhost`, `.`, or `PCname\SQLEXPRESS` if you use Express).
2. In **Object Explorer**, right-click the **Databases** node and select
   **Restore Database…**
3. In the **Source** section, choose **Device** and click the **…** button.
4. In **Select backup devices**, click **Add**, browse to the `.bak` you moved
   in Step 2, select it, and confirm with **OK** (twice).
5. SSMS will read the backup's contents. Under **Destination**, the **Database**
   field fills in automatically (e.g. `AdventureWorks2022`). You can leave it as
   is or shorten it to `AdventureWorks`.
6. *(Recommended)* Go to the **Files** page and check **Relocate all files to folder**
   to make sure the `.mdf` and `.ldf` are saved to a valid path on your machine.
   This avoids errors if the backup was created on another machine.
7. Click **OK** and wait for the successful restore message.
8. Refresh the **Databases** node (right-click → **Refresh**) and your database
   will be ready to use.

### Option 3B · Restore with T-SQL

Before restoring, **read the logical file names** contained in the backup (they
vary by version, so it's best not to guess them):

```sql
RESTORE FILELISTONLY
FROM DISK = 'C:\...\Backup\AdventureWorks2022.bak';
```

The `LogicalName` column gives you the two names you need (one for data and one
for the log). Use them in the `MOVE` clause of the restore command:

```sql
USE [master];
GO
RESTORE DATABASE AdventureWorks
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AdventureWorks2022.bak'
WITH
    MOVE 'AdventureWorks2022'     -- data LogicalName (from FILELISTONLY)
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdventureWorks.mdf',
    MOVE 'AdventureWorks2022_log' -- log LogicalName (from FILELISTONLY)
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdventureWorks_log.ldf',
    REPLACE;
GO
```

> Adjust the paths and logical names to your environment and version.

---

## Step 4 · Verify the installation

Run a quick query to confirm the database responds:

```sql
USE AdventureWorks;
GO
SELECT TOP (10)
    p.FirstName,
    p.LastName
FROM Person.Person AS p;
```

If you see result rows, the restore was successful and you can now run the
repository's queries.

---

## Troubleshooting

| Problem | Likely cause / fix |
|---|---|
| The `.bak` doesn't show up in the SSMS browser | SQL Server lacks permissions on that folder. Move it to the *Backup* folder (Step 2). |
| `Operating system error 5 (Access is denied)` | Folder permissions. Use the *Backup* folder or adjust the SQL Server service account's permissions. |
| `The file ... cannot be overwritten` during restore | Set valid paths under **Relocate all files** (3A) or in the `MOVE` clauses (3B). |
| Wrong logical names in `MOVE` | Run `RESTORE FILELISTONLY` first and copy the `LogicalName` values. |

---

_Once the database is restored, head back to the [main README](../README.md) and
navigate to the section you'd like to explore._
