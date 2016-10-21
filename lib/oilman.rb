lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'awesome_print'
require 'dotenv'
require 'fileutils'
require 'highline/import'
require 'open3'
require 'tiny_tds'
require 'thor'

require 'oilman/backup'
require 'oilman/cli'
require 'oilman/command_line'
require 'oilman/file_info'
require 'oilman/file_list'
require 'oilman/mounter'
require 'oilman/printer'
require 'oilman/restore'

root_dir = File.expand_path('../', lib)

Dotenv.load("#{root_dir}/.env")

Settings = {
  verbose: false,
  mount: {
    user: ENV['MOUNT_USER'],
    server: ENV['MOUNT_SERVER'],
    path: "#{root_dir}/sql_backups",
  },
  db: {
    username: ENV['DB_USER'],
    password: ENV['DB_PASS'],
    host: ENV['DB_HOST'],
    timeout: ENV['DB_TIMEOUT'] || 600,
    database: ENV['DB_NAME'],
  }
}
