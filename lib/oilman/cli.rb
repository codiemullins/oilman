class CLI < Thor
  class_option :verbose, type: :boolean, default: false

  option :search, default: ''
  option :filename, default: ''
  desc "restore SERVER", "restore database .bak file to your chosen SERVER target DB"
  def restore server
    Settings[:verbose] = options[:verbose]
    CommandLine.new(Server.new(server), options[:search], options[:filename]).run
  end

  desc "backup SERVER DATABASE", "Backup specified DATABASE on SERVER (from config.json)"
  def backup server, database
    Backup.new(Server.new(server), database).go
  end
end
