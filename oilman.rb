#!/usr/bin/env ruby

require './lib/oilman.rb'
require 'tiny_tds'

default_filter = ARGV[0] || ""

# client = TinyTds::Client.new username: DB_USER, password: DB_PASS, host: DB_HOST
#
# result = client.execute "SELECT * FROM sys.databases ORDER BY name"
# ap result.map { |r| r['name'] }

PATH = "#{Dir.pwd}/sql_backups"

MOUNTER = Mounter.new MOUNT_USER, MOUNT_SERVER, "/SQL-Server_Backups"

def mount
  status = MOUNTER.mount PATH
end

def list filter = ""
  entries = Dir.entries(PATH).reject { |entry| entry == "." || entry == ".." }
    .select { |entry| filter == "" ? true : entry =~ /#{filter}/i }
    .map do |entry|
      file = "#{PATH}/#{entry}"
      {
        entry: entry,
        directory: File.directory?(file),
        size: File.size(file)
      }
    end
  entries
end

def reduce_list filter = ""
  reduced_list = list filter

  if reduced_list.length > 15
    CLI.say "There are too many backup options... currently have #{reduced_list.length}. Filter the options some..."
    filter = CLI.ask "Search:  "
    reduce_list filter
  else
    reduced_list
  end
end

mount
backup_options = reduce_list default_filter

puts ""

choice = CLI.choose do |menu|
  menu.prompt = "Please choose your backup:  "
  backup_options.each do |option|
    menu.choice(option[:entry]) do
      CLI.say "===="
      if option[:directory]
        CLI.say "You've chosen a directory... I don't support that yet"
      else
        CLI.say "You've chosen a file... I don't support that yet"
      end
      option[:entry]
    end
  end
end

ap choice
