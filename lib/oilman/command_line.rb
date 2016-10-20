class CommandLine
  attr_accessor :filter

  def initialize filter = ""
    path = "#{Dir.pwd}/sql_backups"
    Mounter.new(MOUNT_USER, MOUNT_SERVER, "/SQL-Server_Backups").mount path
  end

  def run
    Printer.print ""
    choice = select_backup { |file| handle_choice file }.gsub '/', '\\'
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
    FileList.new(filter).reduce
  end

  def handle_choice file
    CLI.say "===="
    if file.directory
      select_backup(FileList.new("", "#{PATH}/#{file.name}", true).list) { |file| handle_choice file }
    else
      file.name
    end
  end

end
