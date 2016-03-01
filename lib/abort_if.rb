require "abort_if/version"
require "logger"

module AbortIf
  def self.abort_if test, msg="Fatal error"
    unless test
      self.logger.fatal msg
      abort
    end
  end

  def self.logger
    @@logger ||= Logger.new STDERR
  end
end
