#!/usr/bin/env ruby

require './lib/oilman.rb'

path = "#{Dir.pwd}/sql_backups"

mounter = Mounter.new USERNAME, SERVER, "/SQL-Server_Backups"
status = mounter.mount path

if status.success?
  puts `ls #{path}`
end
# mounter.unmount
