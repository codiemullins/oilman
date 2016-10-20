class Printer

  def self.print msg
    puts(msg)
  end

  def self.debug msg
    puts(msg) if VERBOSE
  end

end
