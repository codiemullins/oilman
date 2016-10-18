#!/usr/bin/env ruby

require './lib/oilman.rb'

require 'benchmark'

PATH = "#{Dir.pwd}/sql_backups"

MOUNTER = Mounter.new USERNAME, SERVER, "/SQL-Server_Backups"

def mount
  status = MOUNTER.mount PATH
end

def list
  entries = Dir.entries(PATH).reject { |entry| entry == "." || entry == ".." }.map do |entry|
    file = "#{PATH}/#{entry}"
    {
      entry: entry,
      directory: File.directory?(file),
      size: File.size(file)
    }
  end
  entries.select { |f| f[:directory] }
  # mounter.unmount
end

Benchmark.bm do |x|
  x.report("mount:") { mount }
  x.report("list:") { list }
end
