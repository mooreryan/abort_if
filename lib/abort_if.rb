require "abort_if/version"
require "abort_if/error"
require "abort_if/argument_error"
require "assert/assert"
require "logger"

module AbortIf
  def abort_if test, msg="Fatal error"
    if test
      logger.fatal msg
      abort
    end
  end

  def abort_if_file_exists fname
    abort_if File.exists?(fname),
             "File '#{fname}' already exists"
  end

  def abort_unless test, msg="Fatal error"
    abort_if !test, msg
  end

  def abort_unless_file_exists fname
    abort_unless File.exists?(fname),
                 "File '#{fname}' does not exist"
  end

  def logger
    @@logger ||= Logger.new STDERR
  end
end
