LIB = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(LIB) unless $LOAD_PATH.include?(LIB)

require 'awesome_print'
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
require 'oilman/server'

class Oilman
  def self.root
    @_root ||= File.expand_path('../', LIB)
  end
end

options = JSON.parse File.read("#{File.dirname(__FILE__)}/../config.json")

Settings = {
  verbose: false,
  mount: {
    domain: options['mount_domain'],
    user: options['mount_user'],
    password: options['mount_password'],
    server: options['mount_server'],
    remote_path: options['mount_path'] || 'X:',
    local_path: "#{Oilman.root}/sql_backups",
  }
}
