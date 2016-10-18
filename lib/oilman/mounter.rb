class Mounter
  attr_reader :user, :server, :path

  def initialize user, server, path = "/"
    @user = user
    @server = server
    @path = path
  end

  def unmount
    stdout, stderr, status = Open3.capture3 "df"
    mount_exists = stdout.include? connection_string
    if mount_exists
      mount = stdout.split("\n").find { |line| line.include? connection_string }
      existing_mount = mount.split(" ").last
      Open3.capture3 "umount #{existing_mount}"
    end
  end

  def mount local_path
    unmount
    FileUtils.mkdir_p local_path
    cmd = mount_command local_path
    stdout, stderr, status = Open3.capture3 cmd
    status
  end

  private

  def connection_string
    "//#{user}@#{server}#{path}"
  end

  def mount_command path
    "mount -t smbfs #{connection_string} #{path}"
  end
end
