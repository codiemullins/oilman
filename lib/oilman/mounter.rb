class Mounter
  attr_reader :config, :path

  def initialize config, path = "/"
    @config = config
    @path = path
  end

  def unmount
    if mount_exists
      mount = stdout.split("\n").find { |line| line.include? connection_string }
      existing_mount = mount.split(" ").last
      Open3.capture3 "umount #{existing_mount}"
    end
  end

  def mount local_path
    return if mount_exists
    unmount
    FileUtils.mkdir_p local_path
    cmd = mount_command local_path
    stdout, stderr, status = Open3.capture3 cmd
    status
  end

  def mount_exists
    stdout, _, _ = Open3.capture3 "df"
    stdout.include? connection_string
  end

  private

  def connection_string
    prefix = config[:domain] ? "//#{config[:domain]}\;" : '//'
    user_password = config[:password] ? "#{config[:user]}:#{config[:password]}" : config[:user]
    "#{prefix}#{user_password}@#{config[:server]}#{path}"
  end

  def mount_command path
    "mount -t smbfs #{connection_string} #{path}"
  end
end
