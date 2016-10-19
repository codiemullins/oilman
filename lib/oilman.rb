lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fileutils'
require 'open3'
require 'dotenv'
require 'awesome_print'
require 'highline'

require 'oilman/mounter'
require 'oilman/file_info'
require 'oilman/file_list'

Dotenv.load

CLI = HighLine.new

MOUNT_USER = ENV['MOUNT_USER']
MOUNT_SERVER = ENV['MOUNT_SERVER']

DB_USER = ENV['DB_USER']
DB_PASS = ENV['DB_PASS']
DB_HOST = ENV['DB_HOST']
