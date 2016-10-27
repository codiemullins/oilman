class BackupFile
  attr_reader :physical_name, :logical_name

  def initialize row
    @physical_name = row['PhysicalName']
    @logical_name = row['LogicalName']
  end

  def log?
    physical_name.include? '.ldf'
  end
end
