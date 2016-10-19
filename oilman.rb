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

def file_list file
  name = file.split("/").last
  return if name == "." || name == ".."
  directory = File.directory? file

  {
    name: name,
    directory: directory,
    size: File.size(file)
  }
end

def list path = PATH, filter = ""
  Dir.entries(path)
    .select { |entry| filter == "" ? true : entry =~ /#{filter}/i }
    .map { |entry| file_list "#{path}/#{entry}" }
    .compact
end

def reduce_list filter = ""
  reduced_list = list PATH, filter

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
    menu.choice(option[:name]) do
      CLI.say "===="
      if option[:directory]
        ap list "#{PATH}/#{option[:name]}"
      else
        CLI.say "You've chosen a file... I don't support that yet"
      end
      option[:name]
    end
  end
end

ap choice
