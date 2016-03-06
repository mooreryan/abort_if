module AbortIf
  module Assert
    class AssertionFailureError < Error
    end

    def assert test, msg="Assertion failed", *args
      unless test
        raise AssertionFailureError, msg % args
      end
    end

    def refute test, msg="Assertion failed", *args
      assert !test, msg, *args
    end

    def assert_includes coll, obj
      check_responds_to coll, :include?

      assert coll.include?(obj),
             "Expected coll to include obj"
    end

    def refute_includes coll, obj
      check_responds_to coll, :include?

      refute coll.include?(obj),
             "Expected coll not to include obj"
    end

    def assert_keys hash, *keys
      check_responds_to hash, :[]

      check_not_empty keys

      assert keys.all? { |key| hash[key] },
             "Expected hash to include all keys"
    end

    def assert_has_key hash, key
      check_responds_to hash, :has_key?

      assert hash.has_key?(key),
             "Expected hash to include key"
    end

    def refute_has_key hash, key
      check_responds_to hash, :has_key?

      refute hash.has_key?(key),
             "Expected hash not to include key"
    end

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