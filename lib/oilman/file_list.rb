class FileList
  attr_reader :path, :filter, :expand_path

  def initialize filter = "", path = "", expand_path = false
    @path = path
    @filter = filter
    @expand_path = expand_path
  end

  def reduce
    reduced_list = list

    if reduced_list.length > 15
      say "There are too many backup options... currently have #{reduced_list.length}. Filter the options some..."
      filter = ask "Search:  "
      FileList.new(filter, path, expand_path).list
    else
      reduced_list
    end
  end

  def list
    Dir.entries(path)
      .select { |entry| filter == "" ? true : entry =~ /#{filter}/i }
      .map { |entry| item "#{path}/#{entry}", expand_path }
      .flatten
      .compact
  end

  def item file, expand_path = false
    name = file.split("/").last
    return if name == "." || name == ".."
    directory = File.directory? file
    return unless name.include?(".bak") || directory

    if directory && expand_path
      dir_files = []
      Dir.foreach(file) { |filename| dir_files.push *item("#{file}/#{filename}") }
      dir_files
    else
      [FileInfo.new(file)]
    end
  end
end
