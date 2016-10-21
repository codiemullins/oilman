class CLI < Thor
  class_option :verbose, type: :boolean, default: false

  option :search, default: ''
  desc "restore", "restore database .bak file to your target DB"
  def restore
    Settings[:verbose] = options[:verbose]
    CommandLine.new(options[:search]).run
  end

  desc "backup DATABASE", "Backup specified DATABASE"
  def backup database
    puts Backup.new(database).go
  end
end
