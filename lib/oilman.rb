lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fileutils'
require 'open3'
require 'dotenv'

Dotenv.load

USERNAME = ENV['USERNAME']
SERVER = ENV['SERVER']
