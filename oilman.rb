#!/usr/bin/env ruby

require 'fileutils'
require 'open3'
require 'dotenv'
Dotenv.load

USERNAME = ENV['USERNAME']
SERVER = ENV['SERVER']

mount = "#{Dir.pwd}/sql_backups"
conn_str = "//#{USERNAME}@#{SERVER}/SQL-Server_Backups"

# Create mount folder
FileUtils.mkdir_p mount

stdout, stderr, pid = Open3.capture3 "df"
puts stdout.include? conn_str

stdout, stderr, pid = Open3.capture3 "mount -t smbfs #{conn_str} #{mount}"
if stderr
  puts "Unable to mount server, unexpected error!"
else
  puts "stdout", stdout, "stderr", stderr, "pid", pid
end
