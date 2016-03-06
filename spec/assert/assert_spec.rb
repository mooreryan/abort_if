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

describe AbortIf::Assert::AssertionFailureError do
  it "is a kind of AbortIf::Error" do
    err = AbortIf::Assert::AssertionFailureError.new
    expect(err).to be_an AbortIf::Error
  end
end

describe AbortIf::Assert do
  let(:klass) { Class.new { extend AbortIf::Assert } }
  let(:hash) { { a: 1, b: 2, c: 3 } }
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


  shared_examples "when a coll doesn't respond" do |calling_method,
                                                    responding_method,
                                                    coll,
                                                    obj|

    context "when coll doesn't respond to :#{responding_method}" do
      it "raises ArgumentError" do
        expect { klass.send(calling_method, coll, obj) }.
          to raise_error AbortIf::ArgumentError
      end
    end
  end

  describe "#assert_includes" do
    include_examples("when a coll doesn't respond",
                     :assert_includes,
                     :include?,
                     5,
                     3)

    context "when coll does not include obj" do
      it "raises AssertionFailureError" do
        coll = [1,2,3]
        obj = 4

        expect_to_raise { klass.assert_includes coll, obj }
      end
    end

    context "when coll inclues obj" do
      it "returns nil" do
        coll = [1,2,3]
        obj = 1

        expect(klass.assert_includes coll, obj).to be nil
      end
    end
  end

  describe "#refute_includes" do
    include_examples("when a coll doesn't respond",
                     :refute_includes,
                     :include?,
                     5,
                     3)

    context "when coll does not include obj" do
      it "returns nil" do
        coll = [1,2,3]
        obj = 4

        expect(klass.refute_includes coll, obj).to be nil
      end
    end

    context "when coll includes obj" do
      it "raises AssertionFailureError" do
        coll = [1,2,3]
        obj = 1

        expect_to_raise { klass.refute_includes coll, obj }
      end
    end
  end

  describe "#assert_keys" do
    include_examples("when a coll doesn't respond",
                     :assert_keys,
                     :[],
                     false,
                     :a)

    context "when no keys are provided" do
      it "raises ArgumentError" do
        expect { klass.assert_keys hash }.
          to raise_error AbortIf::ArgumentError
      end
    end

    context "when all keys have non nil values" do
      it "returns nil" do
        expect(klass.assert_keys hash, :a, :b).to be nil
      end
    end

    context "when at least one key has a nil value" do
      it "raises AssertionFailureError" do
        expect_to_raise { klass.assert_keys hash, :a, :d }
      end
    end
  end

  describe "#assert_has_key" do
    include_examples("when a coll doesn't respond",
                     :assert_has_key,
                     :has_key?,
                     [1,2,3],
                     :a)

    context "when hash has key" do
      it "returns nil" do
        expect(klass.assert_has_key hash, :a).to be nil
      end
    end

    context "when hash does not have key" do
      it "raises AssertionFailureError" do
        expect { klass.assert_has_key hash, :z }.
          to raise_error AbortIf::Assert::AssertionFailureError
      end
    end
  end

  describe "#refute_has_key" do
    include_examples("when a coll doesn't respond",
                     :refute_has_key,
                     :has_key?,
                     [1,2,3],
                     :a)

    context "when hash does not have key" do
      it "returns nil" do
        expect(klass.refute_has_key hash, :z).to be nil
      end
    end

    context "when hash does have key" do
      it "raises AssertionFailureError" do
        expect { klass.refute_has_key hash, :a }.
          to raise_error AbortIf::Assert::AssertionFailureError
      end
    end
  end

  describe "#assert_length" do
    include_examples("when a coll doesn't respond",
                     :assert_length, :length, 5, 5)


    context "when length of coll matches len" do
      it "returns nil" do
        expect(klass.assert_length [1,2,3], 3).to be nil
      end
    end

    context "when length of coll is not len" do
      it "raises AssertionFailureError" do
        expect { klass.assert_length [1,2,3], 2 }.
          to raise_error AbortIf::Assert::AssertionFailureError
      end
    end
  end
end
