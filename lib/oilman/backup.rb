class Backup
  attr_reader :client, :database, :path, :file_name

  def initialize database, path = "", file_name = nil
    @database = database
    @file_name ||= "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{database}_oilman_tmp.bak"
    @path = "#{path.gsub('/', '\\')}\\#{@file_name}"
    @client = TinyTds::Client.new Settings[:db]
  end

  def go
    Printer.print "Backing up database #{database}, this can take upto 30 minutes..."
    sql.split("GO").each_with_index do |s, idx|
      Printer.debug s
      client.execute(s).do
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
