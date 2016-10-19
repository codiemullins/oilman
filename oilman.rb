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

def file_list file, expand_path = false
  name = file.split("/").last
  return if name == "." || name == ".."
  directory = File.directory? file
  return unless name.include?(".bak") || directory

  if directory && expand_path
    dir_files = []
    Dir.foreach(file) { |filename| dir_files.push *file_list("#{file}/#{filename}") }
    dir_files
  else
    [{
      name: file.gsub("#{PATH}/", ""),
      directory: directory,
      size: File.size(file)
    }]
  end
end

def list path = PATH, filter = "", expand_path = false
  Dir.entries(path)
    .select { |entry| filter == "" ? true : entry =~ /#{filter}/i }
    .map { |entry| file_list "#{path}/#{entry}", expand_path }
    .flatten
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

def select_backup list
  CLI.choose do |menu|
    menu.prompt = "Please choose your backup:  "
    list.each do |option|
      menu.choice(option[:name]) do
        CLI.say "===="
        if option[:directory]
          select_backup list "#{PATH}/#{option[:name]}", "", true
        else
          CLI.say "You've chosen a file... I don't support that yet"
          option[:name]
        end
      end
    end
  end
end

backup_options = reduce_list default_filter

puts ""

choice = select_backup backup_options

ap choice
