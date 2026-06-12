# AdventureWorks SQL Server Portfolio

A collection of T-SQL queries and scripts built on Microsoft's
**AdventureWorks** sample database, organized by concept and difficulty level.

> This repository has a twofold goal: to practice and to showcase SQL Server
> skills, from fundamental queries to performance tuning.

## Structure

| Folder | Contents |
|---|---|
| `setup/` | How to download and restore AdventureWorks locally |
| `01-basics/` | SELECT, WHERE, ORDER BY, basic JOINs |
| `02-joins-and-apply/` | Every JOIN type, CROSS/OUTER APPLY |
| `03-aggregations/` | GROUP BY, HAVING, aggregate functions |
| `04-subqueries-and-ctes/` | Subqueries, CTEs, and recursive CTEs |
| `05-window-functions/` | ROW_NUMBER, RANK, LAG/LEAD, running totals |
| `06-tsql-programming/` | Stored procedures, functions, TRY...CATCH, transactions |
| `07-performance-and-indexes/` | Indexes, execution plans, optimization |
| `assets/` | Diagrams and screenshots (execution plans, schema) |

## How to use this repository

1. Restore the database following `setup/README.md`.
2. Navigate to the folder for the topic you're interested in.
3. Each query includes the business problem it solves and an explanation.

---
_SQL Server version used: SQL Server 2025 Developer Edition_
