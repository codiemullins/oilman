class BackupDetail
  attr_reader :name

  def initialize name
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
      RESTORE FILELISTONLY FROM DISK = 'X:\\#{name}' WITH FILE = 1
    SQL

    result = Oilman.client.execute(sql)
    @_files = result.map { |r| BackupFile.new r }
  end
end
