class Restore
  attr_reader :server, :database, :backup, :database_log_name, :user, :db_owner

  def initialize server, backup
    @server = server
    @database = server.database
    @user = server.username == 'sql_admin' ? 'gas_plant' : server.username
    @db_owner = server.db_owner
    @backup = BackupDetail.new server, backup
    @commands = sql.split("GO")
    @length = @commands.length
  end

  def go
    Printer.print "Beginning restore of #{database}... This can take awhile..."
    Printer.print "Go for a short walk or get some coffee..."

    @commands.each_with_index do |command, idx|
      begin
        Printer.debug command
        Printer.print message(idx)
        server.execute command
      rescue TinyTds::Error => e
        set_multi_user
        Printer.print e.message
        Printer.print "Note: Verify services such as god, gora, and rails console aren't running"
        Printer.debug e.backtrace
        return
      end
    end

    Printer.print "Restore is complete! 😁 😆 Happy Coding!"
  end

  private

  def sql
    IO.read("#{Oilman.root}/lib/sql/restore.sql") % {
      database: database,
      user: user,
      db_owner: db_owner,
      timestamp: Time.now.strftime('%Y%m%d%H%M%S'),
      backup: backup.name,
      source_mdf: backup.mdf.logical_name,
      source_ldf: backup.ldf.logical_name,
      data_dir: server.data_dir,
      log_dir: server.log_dir,
      remote_path: Settings[:mount][:remote_path],
    }
  end

  def message idx
    count = idx + 1
    str = "Executing Command #{count} of #{@length}"
    str = "#{str}... <%= color('restore command, this takes the longest by far...', BOLD) %>" if count == 3
    str
  end

  def set_multi_user
    server.execute "ALTER DATABASE #{database} SET MULTI_USER"
  end
end
