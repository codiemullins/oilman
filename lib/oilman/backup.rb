class Backup
  attr_reader :server, :database, :path, :file_name

  def initialize server, database, path = "", file_name = nil
    @server = server
    @database = database
    @file_name ||= "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{database}_oilman_tmp.bak"
    @path = "#{path.gsub('/', '\\')}\\#{@file_name}"
  end

  def go
    Printer.print "Backing up database #{database}, this can take upto 30 minutes..."
    sql.split("GO").each_with_index do |s, idx|
      Printer.debug s
      server.execute s
    end
  end

  def sql
    <<-SQL
      USE #{database};
      GO
      BACKUP DATABASE #{database}
      TO DISK = 'X:\\#{path}'
        WITH NOINIT;
    SQL
  end
end
