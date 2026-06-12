# Setup — Instalar y restaurar AdventureWorks

Esta guía explica cómo descargar la base de datos de ejemplo **AdventureWorks**
de Microsoft y restaurarla en una instancia local de SQL Server, para que puedas
ejecutar las consultas de este repositorio.

AdventureWorks simula a *Adventure Works Cycles*, una empresa ficticia que fabrica
y vende bicicletas y accesorios. Su esquema (ventas, producción, RR.HH., compras)
es lo bastante rico para practicar desde consultas básicas hasta optimización.

---

## Requisitos previos

| Herramienta | Notas |
|---|---|
| **SQL Server** | Edición Developer o Express (ambas gratuitas) sirven. |
| **SQL Server Management Studio (SSMS)** | Para restaurar con interfaz gráfica. |

> AdventureWorks es compatible con SQL Server 2012 y versiones posteriores.

---

## Paso 1 · Descargar el archivo `.bak`

Descarga el backup desde la página oficial de *releases* de Microsoft:

- **Página de descargas:** https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks
- **Documentación oficial:** https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure

En la sección *OLTP backups*, elige la versión que coincida (o sea anterior) a tu
SQL Server. Por ejemplo, descarga **`AdventureWorks2022.bak`** si usas SQL Server 2022.

> **Variantes disponibles:**
> - `AdventureWorks` (OLTP) — la transaccional. **Es la que usa este repositorio.**
> - `AdventureWorksDW` — orientada a *data warehouse* (modelo dimensional).
> - `AdventureWorksLT` — versión ligera y reducida.

Enlace directo de ejemplo:
`https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2022.bak`

---

## Paso 2 · Mover el `.bak` a la carpeta de backups

Mueve el archivo descargado a la carpeta de *Backup* de tu instancia, donde
SQL Server tiene permisos de lectura garantizados. Si lo dejas en *Descargas* o
en el *Escritorio*, es común que la restauración falle por permisos.

La ruta por defecto depende de tu versión de SQL Server:

| Versión | Carpeta de Backup por defecto |
|---|---|
| SQL Server 2019 | `C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\` |
| SQL Server 2022 | `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\` |
| SQL Server 2025 | `C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Backup\` |

> El número tras `MSSQL` cambia según la versión (15 = 2019, 16 = 2022, 17 = 2025).
> Si usas una instancia con nombre, reemplaza `MSSQLSERVER` por el nombre de tu instancia.

---

## Paso 3 · Restaurar la base de datos

Puedes restaurar de dos formas. La interfaz gráfica (3A) es la más sencilla; la
vía por T-SQL (3B) es reproducible y queda como script.

### Opción 3A · Restaurar con SSMS (interfaz gráfica)

1. Abre **SQL Server Management Studio** y conéctate a tu instancia
   (normalmente `localhost`, `.`, o `nombrePC\SQLEXPRESS` si usas Express).
2. En el **Object Explorer**, haz clic derecho sobre el nodo **Databases** y
   selecciona **Restore Database…**
3. En la sección **Source**, elige **Device** y haz clic en el botón **…**
4. En **Select backup devices**, pulsa **Add**, navega hasta el `.bak` que
   moviste en el Paso 2, selecciónalo y confirma con **OK** (dos veces).
5. SSMS leerá el contenido del backup. En **Destination**, el campo **Database**
   se completará solo (p. ej. `AdventureWorks2022`). Puedes dejarlo así o
   acortarlo a `AdventureWorks`.
6. *(Recomendado)* Ve a la página **Files** y marca **Relocate all files to folder**
   para asegurar que el `.mdf` y el `.ldf` se guarden en una ruta válida de tu
   equipo. Esto evita errores si el backup se creó en otra máquina.
7. Pulsa **OK** y espera el mensaje de restauración exitosa.
8. Refresca el nodo **Databases** (clic derecho → **Refresh**) y tu base
   aparecerá lista para usar.

### Opción 3B · Restaurar con T-SQL

Antes de restaurar, **lee los nombres lógicos** de los archivos que contiene el
backup (varían según la versión, así que no conviene adivinarlos):

```sql
RESTORE FILELISTONLY
FROM DISK = 'C:\...\Backup\AdventureWorks2022.bak';
```

La columna `LogicalName` te dará los dos nombres que necesitas (uno de datos y
uno de log). Úsalos en el `MOVE` del comando de restauración:

```sql
USE [master];
GO
RESTORE DATABASE AdventureWorks
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AdventureWorks2022.bak'
WITH
    MOVE 'AdventureWorks2022'     -- LogicalName de datos (de FILELISTONLY)
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdventureWorks.mdf',
    MOVE 'AdventureWorks2022_log' -- LogicalName de log (de FILELISTONLY)
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\AdventureWorks_log.ldf',
    REPLACE;
GO
```

> Ajusta las rutas y los nombres lógicos a tu entorno y versión.

---

## Paso 4 · Verificar la instalación

Ejecuta una consulta rápida para confirmar que la base responde:

```sql
USE AdventureWorks;
GO
SELECT TOP (10)
    p.FirstName,
    p.LastName
FROM Person.Person AS p;
```

Si ves filas de resultado, la restauración fue exitosa y ya puedes ejecutar
las consultas del repositorio.

---

## Solución de problemas

| Problema | Causa probable / solución |
|---|---|
| No aparece el `.bak` en el explorador de SSMS | SQL Server no tiene permisos en esa carpeta. Muévelo a la carpeta de *Backup* (Paso 2). |
| `Operating system error 5 (Access is denied)` | Permisos de carpeta. Usa la carpeta de *Backup* o ajusta permisos de la cuenta de servicio de SQL Server. |
| `The file ... cannot be overwritten` al restaurar | Define rutas válidas en **Relocate all files** (3A) o en los `MOVE` (3B). |
| Nombres lógicos incorrectos en el `MOVE` | Ejecuta primero `RESTORE FILELISTONLY` y copia los valores de `LogicalName`. |

---

_Una vez restaurada la base, vuelve al [README principal](../README.md) y
navega a la sección que quieras explorar._
