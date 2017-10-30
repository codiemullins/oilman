class CommandLine
  attr_reader :server, :filter, :filename, :path

  def initialize server, filter = "", filename = ""
    @server = server
    @filter = filter
    @filename = filename
    @path = Settings[:mount][:local_path]
    Mounter.new(Settings[:mount], "/SQL-Server_Backups").mount path
  end

  def run
    choice = filename != "" ? filename : select_backup { |file| handle_choice file }.gsub('/', '\\')
    Printer.debug "User selected: #{choice}"
    Restore.new(server, choice).go
  end

  def select_backup list = nil
    list ||= options
    choose do |menu|
      menu.prompt = "Please choose your backup:  "
      list.each { |file| menu.choice(file.name) { yield file } }
    end
  end

  def options
    FileList.new(filter, path).reduce
  end

  def handle_choice file
    say "===="
    if file.directory
      select_backup(FileList.new("", "#{path}/#{file.name}", true).list) { |file| handle_choice file }
    else
      file.name
    end
  end

end
