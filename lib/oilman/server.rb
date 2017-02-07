require 'json'

class Server
  attr_reader :settings, :username, :password, :host, :timeout, :database, :data_dir, :log_dir

  def initialize name
    options = JSON.parse File.read("#{File.dirname(__FILE__)}/../../config.json")
    raise("Unable to find server config for #{name}") unless options[name]
    options = options[name]
    @username = options['username']
    @password = options['password']
    @host = options['host']
    @timeout = options['timeout'] || 6000
    @database = options['database']
    @data_dir = options['data_dir'] || 'D:\\MSSQL\\Data'
    @log_dir = options['log_dir'] || 'E:\\MSSQL\\TRNLogs'
  end

  def connection_options
    {
      username: username,
      password: password,
      host: host,
      timeout: timeout,
      database: database,
    }
  end

  def client
    return @_client if @_client
    @_client ||= TinyTds::Client.new connection_options
  end

  def execute sql
    client.execute(sql).do
  end
end
