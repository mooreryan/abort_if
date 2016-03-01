require 'spec_helper'

describe AbortIf do
  let(:klass) { Class.new { extend AbortIf } }
  let(:default_msg) { "Fatal error" }
  let(:hash) { { a: 1, b: 2 } }
  let(:true_test) { hash.has_key? :a }
  let(:false_test) { hash.has_key? :c }

  it 'has a version number' do
    expect(AbortIf::VERSION).not_to be nil
  end

  describe "#abort_if" do
    it "returns nil if test is false" do
      expect(klass.abort_if false_test).to be nil
    end

    it "raises SystemExit if truthy" do
      test = hash.has_key? :a
      expect { klass.abort_if true_test }.to raise_error SystemExit
    end

    it "logs a fatal error" do
      expect(klass.logger).to receive(:fatal).with default_msg

      begin
        klass.abort_if true_test
      rescue SystemExit; end
    end
  end

  describe "#abort_unless" do
    it "doesn't raise SystemExit if test is true" do
      expect(klass.abort_unless true_test).to be nil
    end

    it "raises SystemExit if test is false" do
      expect { klass.abort_unless false_test }.
        to raise_error SystemExit
    end
  end

  describe "#logger" do
    it "returns the module's Logger" do
      expect(klass.logger).to be_an_instance_of Object::Logger
    end
  end
end

describe AbortIf::Assert::AssertionFailureError do
  it "is a kind of Exception" do
    err = AbortIf::Assert::AssertionFailureError.new
    expect(err).to be_an Exception
  end
end

describe AbortIf::Assert do
  let(:klass) { Class.new { extend AbortIf::Assert } }
  let(:passing_test) { 1 == 1 }
  let(:failing_test) { 1 == 2 }
  let(:default_msg) { "Assertion failed" }
  let(:msg) { "%d doesn't equal %d" }
  let(:msg_output) { "1 doesn't equal 2" }

  describe "#assert" do
    it "returns nil if test is truthy" do
      expect(klass.assert passing_test).to be nil
    end

    context "with no message specified" do
      it "raises AbortIf::AssertionFailureError if test is false" do
        expect { klass.assert failing_test } .
          to raise_error(AbortIf::Assert::AssertionFailureError,
                         default_msg)
      end
    end

    context "with a message" do
      it "raises and interpolates message arguments" do
        msg = "%d doesn't equal %d"

        expect { klass.assert failing_test, msg, 1, 2 } .
          to raise_error(AbortIf::Assert::AssertionFailureError,
                         "1 doesn't equal 2")
      end
    end
  end

  describe "#refute" do
    it "returns nil if test is false" do
      expect(klass.refute failing_test).to be nil
    end

    it "raises AssertionFailureError when test is truthy" do
      expect { klass.refute passing_test, msg, 1, 2 } .
        to raise_error(AbortIf::Assert::AssertionFailureError,
                       msg_output)
    end
  end
end
