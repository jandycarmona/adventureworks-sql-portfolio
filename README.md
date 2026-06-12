# AdventureWorks SQL Server Portfolio

Colección de consultas y scripts T-SQL sobre la base de datos de ejemplo
**AdventureWorks** de Microsoft, organizada por concepto y nivel de dificultad.

> El objetivo de este repositorio es doble: practicar y demostrar habilidades
> en SQL Server, desde consultas fundamentales hasta optimización de rendimiento.

## Estructura

| Carpeta | Contenido |
|---|---|
| `setup/` | Cómo descargar y restaurar AdventureWorks en local |
| `01-basics/` | SELECT, WHERE, ORDER BY, JOINs básicos |
| `02-joins-and-apply/` | Todos los tipos de JOIN, CROSS/OUTER APPLY |
| `03-aggregations/` | GROUP BY, HAVING, funciones de agregación |
| `04-subqueries-and-ctes/` | Subconsultas, CTEs y CTEs recursivos |
| `05-window-functions/` | ROW_NUMBER, RANK, LAG/LEAD, totales acumulados |
| `06-tsql-programming/` | Stored procedures, funciones, TRY...CATCH, transacciones |
| `07-performance-and-indexes/` | Índices, planes de ejecución, optimización |
| `assets/` | Diagramas y capturas (planes de ejecución, esquema) |

## Cómo usar este repositorio

1. Restaura la base de datos siguiendo `setup/README.md`.
2. Navega a la carpeta del tema que te interese.
3. Cada query incluye el problema de negocio que resuelve y su explicación.

---
_Versión de SQL Server usada: SQL Server 2025 Developer Edition_
