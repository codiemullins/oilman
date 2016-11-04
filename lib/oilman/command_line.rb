class CommandLine
  attr_reader :filter, :path

  def initialize filter = ""
    @filter = filter
    @path = Settings[:mount][:local_path]
    Mounter.new(Settings[:mount][:user], Settings[:mount][:server], "/SQL-Server_Backups").mount path
  end

  def run
    choice = select_backup { |file| handle_choice file }.gsub '/', '\\'
    Printer.debug "User selected: #{choice}"
    Restore.new(Settings[:db], choice).go
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
