# Copyright 2016 Ryan Moore
# Contact: moorer@udel.edu
#
# This file is part of AbortIf.
#
# AbortIf is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# AbortIf is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with AbortIf.  If not, see <http://www.gnu.org/licenses/>.

require "abort_if/version"
require "abort_if/error"
require "abort_if/argument_error"
require "assert/assert"
require "logger"

module AbortIf
  # Writes a message to the logger then calls abort if test is truthy,
  # else returns nil.
  #
  # If test is true, write contents of msg to an error logger, then
  # abort.
  #
  # @example When test is true
  #   arr = []
  #   abort_if arr.empty?, "Array empty"
  #   # Prints this message to standard error, then exits
  #   F, [2016-03-06T18:14:03.255900 #5357] FATAL -- : Array empty
  #
  # @example When test is false
  #   arr = [1,2,3]
  #   abort_if arr.empty?, "Array empty"
  #   #=> nil
  #
  # @param test Some object or test
  # @param msg [String] the message written by the
  #   error logger
  #
  # @raise [SystemExit] if test is truthy
  #
  # @return [nil] if test is false or nil
  #
  # @note The abort_if style methods don't interpolate arguments to
  #   msg as the Assert module methods do
  def abort_if test, msg="Fatal error"
    if test
      logger.fatal msg
      abort
    end
  end

  # Writes a message to the logger then aborts if fname is a file that
  # already exists.
  #
  # @param fname [String] name of a file
  #
  # @raise [SystemExit] if file exists
  #
  # @return [nil] if file does not exist
  def abort_if_file_exists fname
    abort_if File.exists?(fname),
             "File '#{fname}' already exists"
  end

  # Writes a message to the logger then calls abort if test is false
  # or nil, else returns nil.
  #
  # @example When test is true
  #   arr = []
  #   abort_unless arr.empty?, "Array should be empty"
  #   #=> nil
  #
  # @example When test is false
  #   arr = [1,2,3]
  #   abort_unless arr.empty?, "Array not empty"
  #   # Prints this message to standard error, then exits
  #   F, [2016-03-06T18:14:03.255900 #5357] FATAL -- : Array not empty
  #
  # @param (see #abort_if)
  #
  # @raise [SystemExit] if test is false or nil
  #
  # @return [nil] if test is truthy
  def abort_unless test, msg="Fatal error"
    abort_if !test, msg
  end

  # Writes a message to the logger then aborts if fname is a file that
  # does not exist.
  #
  # @param (see #abort_if_file_exists)
  #
  # @raise [SystemExit] if file does not exist
  #
  # @return [nil] if file exists
  def abort_unless_file_exists fname
    abort_unless File.exists?(fname),
                 "File '#{fname}' does not exist"
  end

  # Returns a Logger.
  #
  # This method will create an instance of Logger with all the default
  # options if one does not already exist. If a logger has already
  # been created, return the old one.
  #
  # @example Logging an error
  #   logger.error "An error occured"
  #
  # @return [Logger] a module level instance of Logger
  #
  # @note There is only one logger for the module.
  # @note You can modify this logger just any of the Logger class from
  #   the Ruby standard library (see
  #   http://ruby-doc.org/stdlib-2.2.0/libdoc/logger/rdoc/Logger.html)
  def logger
    @@logger ||= Logger.new STDERR
  end
end
