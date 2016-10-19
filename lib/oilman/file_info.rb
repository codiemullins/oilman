class FileInfo
  attr_reader :name, :directory, :size
  def initialize file
    @name = file.gsub("#{PATH}/", "")
    @directory = File.directory? file
    @size = File.size file
  end
end
