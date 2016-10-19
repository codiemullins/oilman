restore = Restore.new({
  username: DB_USER,
  password: DB_PASS,
  host: DB_HOST,
  timeout: DB_TIMEOUT,
  database: ENV['DB_NAME']
}, "codie\\20161019144811_qa_5.bak")

# This returns an array of hashes with information needed to do a real restore, sample output below

# [
#     [0] {
#                  "LogicalName" => "howard_staging",
#                 "PhysicalName" => "D:\\MSSQL\\Data\\qa_5.mdf",
#                         "Type" => "D",
#                "FileGroupName" => "PRIMARY",
#                         "Size" => 15178137600,
#                      "MaxSize" => 35184372080640
#     },
#     [1] {
#                  "LogicalName" => "howard_staging_log",
#                 "PhysicalName" => "E:\\MSSQL\\TRN_Logs\\qa_5_1.ldf",
#                         "Type" => "L",
#                "FileGroupName" => nil,
#                         "Size" => 2677604352,
#                      "MaxSize" => 2199023255552
#     }
# ]

restore.file_list


sql = <<-SQL
USE master
GO

ALTER DATABASE [#{database_name}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

SET deadlock_priority high

USE master;
RESTORE DATABASE [#{database_name}]
   FROM DISK = 'X:\\#{choice}'
   WITH  FILE = 1,  MOVE N'foundation_staging' TO N'D:\MSSQL\Data\codie_db.mdf',  MOVE N'foundation_staging_log' TO N'E:\MSSQL\TRNLogs\codie_db_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
GO

EXEC [#{database_name}].dbo.sp_changedbowner @loginame = N'gas_plant', @map = false
GO

DECLARE @DBNAME VARCHAR(100)
SET @DBNAME = '#{database_name}'

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
SQL

puts "Restoring DB to #{database_name}..."

client = TinyTds::Client.new username: DB_USER, password: DB_PASS, host: DB_HOST, timeout: DB_TIMEOUT
sql.split("GO").each do |s|
  puts s
  client.execute(s).do
  sleep 1
  # ap result.map { |r| r['name'] }
end

puts "Restoration of DB is now complete. Happy Coding!"
