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

module AbortIf
  module Assert
    # Error raised when any assert or refute method fails
    class AssertionFailureError < Error
    end

    # If test is true, return nil, else raise AssertionFailureError
    # with the given message.
    #
    # @example Test is true
    #   a, b = 1, 1
    #   assert a == b, "%d should equal %d", a, b
    #   #=> nil
    #
    # @example Test is false
    #   arr = [1,2,3]
    #   assert arr.empty?,
    #          "Array should be empty, had %d items"
    #          arr.count
    #   # raises AssertionFailureError with given msg
    #
    # @param test Some object or test
    # @param msg [String] the message passed to the
    #   AssertionFailureError
    # @param *args arguments to interpolate into msg
    #
    # @raise [AssertionFailureError] if test is false or nil
    #
    # @return [nil] if test is truthy
    def assert test, msg="Assertion failed", *args
      unless test
        raise AssertionFailureError, msg % args
      end
    end

    # If test is false or nil, return nil, else raise
    # AssertionFailureError.
    #
    # @param (see #assert)
    #
    # @raise [AssertionFailureError] if test is truthy
    #
    # @return [nil] if thest is false or nil
    #
    # @note The opposite of assert
    def refute test, msg="Assertion failed", *args
      assert !test, msg, *args
    end

    # If coll includes obj, return nil, else raise
    # AssertionFailureError.
    #
    # @example Passing
    #   assert_includes [1,2,3], 1
    #   #=> nil
    #
    # @example Failing
    #   assert_includes [1,2,3], 10
    #   # raises AssertionFailureError
    #
    # @param coll [#include?] some collection
    # @param obj the object to check for
    #
    # @raise [AssertionFailureError] if coll does not include object
    # @raise [ArgumentError] if coll does not respond to :include?
    #
    # @return [nil] if coll includes obj
    def assert_includes coll, obj
      check_responds_to coll, :include?

      assert coll.include?(obj),
             "Expected coll to include obj"
    end

    # If coll includes obj, raise AssertionFailureError, else return
    # nil.
    #
    # @param (see #assert_includes)
    #
    # @raise [AssertionFailureError] if coll does include object
    # @raise [ArgumentError] if coll doesn't respond to :include?
    #
    # @return [nil] if coll does not include obj
    def refute_includes coll, obj
      check_responds_to coll, :include?

      refute coll.include?(obj),
             "Expected coll not to include obj"
    end

    # If any key is not present in coll, raise AssertionFailureError,
    # else return nil.
    #
    # @example Passing
    #   assert_keys {a: 2, b: 1}, :a, :b
    #   #=> nil
    #
    # @example Failing
    #   assert_keys {a: 2, b: 1}, :a, :b, :c
    #   # raises AssertionFailureError
    #
    # @param coll [#[]] collection of things
    # @param *keys keys to check for
    #
    # @raise [AssertionFailureError] if coll does include every key
    # @raise [ArgumentError] if coll doesn't respond to :[]
    #
    # @return [nil] if coll has every key
    def assert_keys coll, *keys
      check_responds_to coll, :[]

      check_not_empty keys

      assert keys.all? { |key| coll[key] },
             "Expected coll to include all keys"
    end

    # If the key is present in hash, return nil, else raise
    # AssertionFailureError.
    #
    # @example Passing
    #   assert_has_key {a: 2, b: 1}, :a
    #   #=> nil
    #
    # @example Failing
    #   assert_has_key {a: 2, b: 1}, :c
    #   # raises AssertionFailureError
    #
    # @param hash [#has_key?] anything that responds to :has_key?
    # @param key the key to check for
    #
    # @raise [AssertionFailureError] if hash doesn't include key
    # @raise [ArgumentError] if coll doesn't respond to :has_key?
    #
    # @return [nil] if hash has key
    def assert_has_key hash, key
      check_responds_to hash, :has_key?

      assert hash.has_key?(key),
             "Expected hash to include key"
    end

    # If the key is present in hash, raise AssertionFailureError, else
    # return nil.
    #
    # @example Passing
    #   refute_has_key {a: 2, b: 1}, :a
    #   # raises AssertionFailureError
    #
    # @example Failing
    #   refute_has_key {a: 2, b: 1}, :c
    #   #=> nil
    #
    # @param (see #assert_has_key)
    #
    # @raise [AssertionFailureError] if hash includes key
    # @raise [ArgumentError] if coll doesn't respond to :has_key?
    #
    # @return [nil] if hash does not have key
    def refute_has_key hash, key
      check_responds_to hash, :has_key?

      refute hash.has_key?(key),
             "Expected hash not to include key"
    end

    # If coll is given length, return nil, else raise
    # AssertionFailureError.
    #
    # @param coll [#length] anything that responds to :length
    # @param len [Number] the length to check for
    #
    # @raise [AssertionFailureError] if length of coll doesn't match
    #   given len
    # @raise [ArgumentError] if coll doesn't respond to :length
    #
    # @return [nil] if length of coll matches given len
    def assert_length coll, len
      check_responds_to coll, :length

      assert coll.length == len,
             "Expected coll to have %d items",
             len
    end

    private

    def check_responds_to coll, method
      raise ArgumentError unless coll.respond_to? method
    end

    def check_not_empty coll
      check_responds_to coll, :count

      raise ArgumentError unless coll.count > 0
    end
  end
end
