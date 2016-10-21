class Restore
  attr_reader :client, :database, :backup, :database_log_name

  def initialize connection_options, backup
    @database = connection_options[:database]
    @backup = backup
    @client = TinyTds::Client.new connection_options
  end

  def go
    Printer.print "Beginning restore of #{database}... This can take awhile..."
    Printer.print "Go for a short walk or get some coffee..."

    commands = restore_sql.split("GO")
    total_commands = commands.length

    commands.each_with_index do |s, idx|
      Printer.debug s
      message = "Executing Command #{idx + 1} of #{total_commands}"
      message = "#{message}... <%= color('restore command, this takes the longest by far...', BOLD) %>" if idx + 1 == 2
      Printer.print message
      begin
        client.execute(s).do
      rescue TinyTds::Error => e
        client.execute("ALTER DATABASE #{database} SET MULTI_USER").do
        puts e.message
        puts "Verify services such as god, gora, and rails console aren't running"
        puts e.backtrace.inspect
      end
      sleep 1
    end

    Printer.print "Restore is complete! 😁 😆 Happy Coding!"
  end

  def file_list
    sql = <<-SQL
      USE master;
      RESTORE FILELISTONLY FROM DISK = 'X:\\#{backup}' WITH FILE = 1
    SQL

    result = client.execute(sql)
    result.map { |r| r }
  end

  def restore_sql
    <<-SQL
      USE master
      GO

      ALTER DATABASE [#{database}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

      SET deadlock_priority high

      #{restore_command}
      GO

      EXEC [#{database}].dbo.sp_changedbowner @loginame = N'gas_plant', @map = false
      GO

      ALTER DATABASE #{database} SET MULTI_USER
      ALTER DATABASE #{database} SET RECOVERY SIMPLE

      USE #{database}
      DBCC SHRINKFILE(#{database_log_name}, 2)
      GO

      ALTER DATABASE #{database} SET ANSI_NULLS ON
      ALTER DATABASE #{database} SET ANSI_PADDING ON
      ALTER DATABASE #{database} SET ANSI_WARNINGS ON
      ALTER DATABASE #{database} SET ARITHABORT ON
      ALTER DATABASE #{database} SET CONCAT_NULL_YIELDS_NULL ON
      ALTER DATABASE #{database} SET QUOTED_IDENTIFIER ON
    SQL
  end

  def restore_command
    move = move_sql.join(', ')

    <<-SQL
      USE master;
      RESTORE DATABASE [#{database}]
        FROM DISK = 'X:\\#{backup}'
        WITH FILE = 1,
        #{move},
        NOUNLOAD, REPLACE, STATS = 5
    SQL
  end

  def move_sql
    file_list.map do |row|
      is_log = row['LogicalName'].include? "_log"
      if is_log
        @database_log_name = row['LogicalName']
        path = "E:\\MSSQL\\TRNLogs\\#{database}_log.ldf"
      else
        path = "D:\\MSSQL\\Data\\#{database}.mdf"
      end
      "MOVE '#{row['LogicalName']}' TO '#{path}'"
    end
  end
end
