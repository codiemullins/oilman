LIB = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(LIB) unless $LOAD_PATH.include?(LIB)

require 'awesome_print'
require 'dotenv'
require 'fileutils'
require 'highline/import'
require 'open3'
require 'tiny_tds'
require 'thor'

require 'oilman/backup'
require 'oilman/backup_detail'
require 'oilman/backup_file'
require 'oilman/cli'
require 'oilman/command_line'
require 'oilman/file_info'
require 'oilman/file_list'
require 'oilman/mounter'
require 'oilman/printer'
require 'oilman/restore'

class Oilman
  def self.root
    @_root ||= File.expand_path('../', LIB)
  end

  def self.connection_options
    {
      username: ENV['DB_USER'],
      password: ENV['DB_PASS'],
      host: ENV['DB_HOST'],
      timeout: ENV['DB_TIMEOUT'] || 6000,
      database: ENV['DB_NAME'],
    }
  end

  def self.client
    @_client ||= TinyTds::Client.new connection_options
  end

  def self.execute sql
    client.execute(sql).do
  end
end

Dotenv.load("#{Oilman.root}/.env")

Settings = {
  verbose: false,
  mount: {
    user: ENV['MOUNT_USER'],
    server: ENV['MOUNT_SERVER'],
    path: "#{Oilman.root}/sql_backups",
  },
  db: {
    username: ENV['DB_USER'],
    password: ENV['DB_PASS'],
    host: ENV['DB_HOST'],
    timeout: ENV['DB_TIMEOUT'] || 6000,
    database: ENV['DB_NAME'],
  }
}
