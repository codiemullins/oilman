class CommandLine
  attr_reader :filter, :path

  def initialize filter = ""
    @filter = filter
    @path = MOUNT_PATH
    Mounter.new(MOUNT_USER, MOUNT_SERVER, "/SQL-Server_Backups").mount path
  end

  def run
    Printer.print ""
    choice = select_backup { |file| handle_choice file }.gsub '/', '\\'
    Printer.debug "User selected: #{choice}"
    Restore.new(CONN, choice).go
  end


  def select_backup list = nil
    list ||= options
    CLI.choose do |menu|
      menu.prompt = "Please choose your backup:  "
      list.each { |file| menu.choice(file.name) { yield file } }
    end
  end

  def options
    FileList.new(filter, path).reduce
  end

  def handle_choice file
    CLI.say "===="
    if file.directory
      select_backup(FileList.new("", "#{path}/#{file.name}", true).list) { |file| handle_choice file }
    else
      file.name
    end
  end

end
