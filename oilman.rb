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
MOUNTER.mount PATH

def select_backup list
  CLI.choose do |menu|
    menu.prompt = "Please choose your backup:  "
    list.each { |file| menu.choice(file.name) { yield file } }
  end
end

def handle_choice file
  CLI.say "===="
  if file.directory
    select_backup(FileList.new("", "#{PATH}/#{file.name}", true).list) { |file| handle_choice file }
  else
    CLI.say "You've chosen a file... I don't support that yet"
    file.name
  end
end

backup_options = FileList.new(default_filter).reduce

puts ""

choice = select_backup(backup_options) { |file| handle_choice file }

ap choice
