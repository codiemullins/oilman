class BackupDetail
  attr_reader :server, :name

  def initialize server, name
    @server = server
    @name = name.gsub "/", "\\"
  end

  def mdf
    @_mdf ||= files.find { |file| !file.log? }
  end

  def ldf
    @_ldf ||= files.find { |file| file.log? }
  end

  private

  def files
    return @_files if @_files

    sql = <<-SQL
      USE master;
      RESTORE FILELISTONLY FROM DISK = '#{Settings[:mount][:remote_path]}\\#{name}' WITH FILE = 1
    SQL

    Printer.debug sql

    result = server.client.execute sql
    @_files = result.map { |r| BackupFile.new r }
  end
end
