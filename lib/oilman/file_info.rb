class FileInfo
  attr_reader :name, :directory, :size
  def initialize file
    @name = file.gsub("#{MOUNT_PATH}/", "")
    @directory = File.directory? file
    @size = File.size file
  end
end
