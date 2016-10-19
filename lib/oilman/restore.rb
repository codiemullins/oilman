class Restore
  attr_reader :client, :database, :backup

  def initialize connection_options, backup
    @database = connection_options[:database]
    @backup = backup
    @client = TinyTds::Client.new connection_options
  end

  def go
    file_list
  end

  def file_list
    puts backup
    sql = <<-SQL
      USE master;
      RESTORE FILELISTONLY FROM DISK = 'X:\\#{backup}' WITH FILE = 1
    SQL

    sql.split("GO").each do |s|
      puts s
      result = client.execute(s)
      ap result.map { |r| r}
    end
  end
end
