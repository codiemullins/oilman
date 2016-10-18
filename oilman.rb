#!/usr/bin/env ruby

require './lib/oilman.rb'
require 'tiny_tds'

client = TinyTds::Client.new username: DB_USER, password: DB_PASS, host: DB_HOST

result = client.execute "SELECT * FROM sys.databases ORDER BY name"
ap result.map { |r| r['name'] }

# PATH = "#{Dir.pwd}/sql_backups"
#
# MOUNTER = Mounter.new MOUNT_USER, MOUNT_SERVER, "/SQL-Server_Backups"
#
# def mount
#   status = MOUNTER.mount PATH
# end
#
# def list
#   entries = Dir.entries(PATH).reject { |entry| entry == "." || entry == ".." }.map do |entry|
#     file = "#{PATH}/#{entry}"
#     {
#       entry: entry,
#       directory: File.directory?(file),
#       size: File.size(file)
#     }
#   end
#   entries.select { |f| f[:directory] }
#   # mounter.unmount
# end
#
# mount
# ap list
