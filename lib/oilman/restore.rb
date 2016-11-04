class Restore
  attr_reader :database, :backup, :database_log_name, :user

  def initialize connection_options, backup
    @database = connection_options[:database]
    @user = connection_options[:username]
    @backup = BackupDetail.new(backup)
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
        Oilman.execute command
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
      timestamp: Time.now.strftime('%Y%m%d%H%M%S'),
      backup: backup.name,
      source_mdf: backup.mdf.logical_name,
      source_ldf: backup.ldf.logical_name,
      data_dir: Settings[:db][:data_dir],
      log_dir: Settings[:db][:log_dir],
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
    Oilman.execute "ALTER DATABASE #{database} SET MULTI_USER"
  end
end
