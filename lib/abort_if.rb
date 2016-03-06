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
