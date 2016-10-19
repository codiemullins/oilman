# oilman
Easily restore a DB from the command line

Sample use case below

```bash
$ ./oilman.rb talis

1. Talisman
2. TalismanSocAuditJuly2016.tar.gz
3. TalismanSocAudit.tar
4. 20160906-talisman_clone.bak
Please choose your backup:  1
====
You've chosen a directory... I don't support that yet
"Talisman"

$ ./oilman.rb
There are too many backup options... currently have 135. Filter the options some...
Search:  talis

1. Talisman
2. TalismanSocAuditJuly2016.tar.gz
3. TalismanSocAudit.tar
4. 20160906-talisman_clone.bak
Please choose your backup:  1
====
You've chosen a directory... I don't support that yet
"Talisman"
```

## Sample SQL to create DB backup

Substitute `database_name` for the name of the database and `path_to_bak_file` for the path to store the `.bak` file on the NAS.

```sql
USE {database_name};
GO
BACKUP DATABASE {database_name}
TO DISK = 'X:\{path_to_bak_file}'
   WITH NOINIT;
GO
```

## Sample SQL for DB Restore

Substitute `database_name` for the name of the database and `path_to_bak_file` for the path to the `.bak` file on the NAS.

```sql
use master
go

ALTER DATABASE [{database_name}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

set deadlock_priority high

USE master
RESTORE DATABASE [{database_name}]
   FROM DISK = 'X:\{path_to_bak_file}'
GO

EXEC [{database_name}].dbo.sp_changedbowner @loginame = N'gas_plant', @map = false
go

DECLARE @DBNAME VARCHAR(100)
SET @DBNAME = '{database_name}'

DECLARE @TRNLOGFILE VARCHAR(100)
SET @TRNLOGFILE = 'WDO_log'

DECLARE @DBOPTIONS VARCHAR(MAX)
SET @DBOPTIONS = '
ALTER DATABASE {DBNAME} SET MULTI_USER

ALTER DATABASE {DBNAME} SET RECOVERY SIMPLE

USE {DBNAME}
DBCC SHRINKFILE({TRNLOGFILE}, 2)

ALTER DATABASE {DBNAME} SET ANSI_NULLS ON
ALTER DATABASE {DBNAME} SET ANSI_PADDING ON
ALTER DATABASE {DBNAME} SET ANSI_WARNINGS ON
ALTER DATABASE {DBNAME} SET ARITHABORT ON
ALTER DATABASE {DBNAME} SET CONCAT_NULL_YIELDS_NULL ON
ALTER DATABASE {DBNAME} SET QUOTED_IDENTIFIER ON
'


DECLARE @SC1 VARCHAR(MAX)
DECLARE @SC2 VARCHAR(MAX)
SET @SC1 = REPLACE(@DBOPTIONS, '{DBNAME}', @DBNAME)
--SET @SC2 = REPLACE(@SC1, '{TRNLOGFILE}', @TRNLOGFILE)
EXECUTE (@SC2)
```
