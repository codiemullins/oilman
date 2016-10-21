lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'awesome_print'
require 'dotenv'
require 'fileutils'
require 'highline'
require 'open3'
require 'tiny_tds'
require 'thor'

require 'oilman/backup'
require 'oilman/command_line'
require 'oilman/file_info'
require 'oilman/file_list'
require 'oilman/mounter'
require 'oilman/printer'
require 'oilman/restore'

root_dir = File.expand_path('../', lib)

Dotenv.load("#{root_dir}/.env")

CLI = HighLine.new

VERBOSE = ENV['VERBOSE'] || false

MOUNT_USER = ENV['MOUNT_USER']
MOUNT_SERVER = ENV['MOUNT_SERVER']
MOUNT_PATH = "#{root_dir}/sql_backups"

DB_USER = ENV['DB_USER']
DB_PASS = ENV['DB_PASS']
DB_HOST = ENV['DB_HOST']
DB_NAME = ENV['DB_NAME']
DB_TIMEOUT = ENV['DB_TIMEOUT'] || 600

CONN = {
  username: DB_USER,
  password: DB_PASS,
  host: DB_HOST,
  timeout: DB_TIMEOUT,
  database: DB_NAME
}
