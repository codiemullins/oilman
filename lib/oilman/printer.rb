class Printer

  def self.print msg
    say msg
  end

  def self.debug msg
    say(msg) if Settings[:verbose]
  end

end
