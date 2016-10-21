class Backup
  attr_reader :database, :path, :file_name

  def initialize database, path = "", file_name = nil
    @database = database
    @file_name ||= "#{Time.now.strftime('%Y%m%d%H%M%S')}_oilman_tmp.bak"
    @path = "#{path.gsub('/', '\\')}\\#{@file_name}"
  end

  def go
    sql = <<-SQL
      USE #{database};
      GO
      BACKUP DATABASE #{database}
      TO DISK = 'X:\\#{path}'
        WITH NOINIT;
      GO
    SQL
  end
end
