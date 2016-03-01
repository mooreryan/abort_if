require 'spec_helper'

describe AbortIf do

  let(:default_msg) { "Fatal error" }

  it 'has a version number' do
    expect(AbortIf::VERSION).not_to be nil
  end

  describe "::abort_if" do
    it "returns nil if test is truthy" do
      test = :apple
      expect(AbortIf.abort_if test).to be nil
    end

    it "raises SystemExit if false or nil" do
      test = false
      expect { AbortIf.abort_if test }.to raise_error SystemExit
    end

    it "logs a fatal error" do
      expect(AbortIf.logger).to receive(:fatal).with default_msg

      begin
        AbortIf.abort_if false
      rescue SystemExit; end
    end
  end

  describe "::logger" do
    it "returns the module's Logger" do
      expect(AbortIf.logger).to be_an_instance_of Object::Logger
    end
  end
end
