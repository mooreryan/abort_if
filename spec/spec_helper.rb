$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'abort_if'

def expect_to_raise
  expect { yield }.
    to raise_error AbortIf::Assert::AssertionFailureError
end
