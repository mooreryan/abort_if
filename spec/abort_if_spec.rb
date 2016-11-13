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

require 'spec_helper'

describe AbortIf do
  let(:klass) { Class.new { extend AbortIf } }
  let(:default_msg) { "Fatal error" }
  let(:hash) { { a: 1, b: 2, c: 3 } }
  let(:true_test) { hash.has_key? :a }
  let(:false_test) { hash.has_key? :d }
  let(:file) { "#{File.dirname(__FILE__)}/test_files/hello.txt" }
  @msg = "Fatal error"

  it 'has a version number' do
    expect(AbortIf::VERSION).not_to be nil
  end

  describe "AbortIf::Exit" do
    it "is a SystemExit" do
      err = AbortIf::Exit.new
      expect(err).to be_a SystemExit
    end
  end

  describe "Error" do
    it "is a StandardError" do
      err = AbortIf::Error.new
      expect(err).to be_a StandardError
    end
  end

  describe "ArgumentError" do
    it "is an Error" do
      err = AbortIf::ArgumentError.new
      expect(err).to be_an AbortIf::Error
    end
  end

  shared_examples "for logging a fatal error" do |method, test|
    it "logs a fatal error" do
      expect(klass.logger).to receive(:fatal)

      begin
        klass.send(method, test)
      rescue AbortIf::Exit
        # pass
      end
    end

    it "sets the exit code to 1" do
      begin
        klass.send(method, test)
      rescue AbortIf::Exit => e
        expect(e.status).to eq 1
      end
    end
  end

  describe "#abort_if" do
    it "returns nil if test is false" do
      expect(klass.abort_if false_test).to be nil
    end

    it "raises AbortIf::Exit with msg if truthy" do
      test = hash.has_key? :a
      msg = "Teehee"
      expect { klass.abort_if true_test, msg }.
        to raise_error AbortIf::Exit, msg
    end

    include_examples "for logging a fatal error", :abort_if, true
  end

  describe "#abort_if_file_exists" do
    @fname = "#{File.dirname(__FILE__)}/test_files/hello.txt"
    it "doesn't raise AbortIf::Exit if file does NOT exist" do
      expect(klass.abort_if_file_exists "fake_file.txt").to be nil
    end

    it "raises AbortIf::Exit if file already exist" do
      expect { klass.abort_if_file_exists file }.
        to raise_error AbortIf::Exit
    end

    include_examples "for logging a fatal error",
                     :abort_if_file_exists,
                     @fname
  end

  describe "#abort_unless" do
    it "doesn't raise AbortIf::Exit if test is true" do
      expect(klass.abort_unless true_test).to be nil
    end

    it "raises AbortIf::Exit if test is false" do
      expect { klass.abort_unless false_test }.
        to raise_error AbortIf::Exit
    end

    include_examples "for logging a fatal error", :abort_unless, false
  end

  describe "#abort_unless_file_exists" do
    it "doesn't raise AbortIf::Exit if file exists" do
      expect(klass.abort_unless_file_exists file).to be nil
    end

    it "raises AbortIf::Exit if file doesn't exist" do
      expect { klass.abort_unless_file_exists "apples" }.
        to raise_error AbortIf::Exit
    end

    include_examples "for logging a fatal error",
                     :abort_unless_file_exists,
                     "fake_file.txt"
  end

  describe "#logger" do
    it "returns the module's Logger" do
      expect(klass.logger).to be_an_instance_of Object::Logger
    end
  end
end
