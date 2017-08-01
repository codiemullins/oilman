USE master
GO

SET deadlock_priority high

ALTER DATABASE[%{database}] SET MULTI_USER
GO

ALTER DATABASE [%{database}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

SET deadlock_priority high

USE master;
RESTORE DATABASE [%{database}]
  FROM DISK = '%{remote_path}\%{backup}'
  WITH FILE = 1,
  MOVE '%{source_mdf}' TO '%{data_dir}\%{database}_%{timestamp}.mdf',
  MOVE '%{source_ldf}' TO '%{log_dir}\%{database}_%{timestamp}_log.ldf',
  NOUNLOAD, REPLACE, STATS = 5
GO

EXEC [%{database}].dbo.sp_changedbowner @loginame = N'%{db_owner}', @map = false
GO

ALTER DATABASE %{database} SET MULTI_USER
ALTER DATABASE %{database} SET RECOVERY SIMPLE

USE %{database}
DBCC SHRINKFILE('%{source_ldf}', 2)
GO

ALTER DATABASE %{database} SET ANSI_NULLS ON
ALTER DATABASE %{database} SET ANSI_PADDING ON
ALTER DATABASE %{database} SET ANSI_WARNINGS ON
ALTER DATABASE %{database} SET ARITHABORT ON
ALTER DATABASE %{database} SET CONCAT_NULL_YIELDS_NULL ON
ALTER DATABASE %{database} SET QUOTED_IDENTIFIER ON
