# AbortIf

[![Gem Version](https://badge.fury.io/rb/abort_if.svg)](https://badge.fury.io/rb/abort_if) [![Build Status](https://travis-ci.org/mooreryan/abort_if.svg?branch=master)](https://travis-ci.org/mooreryan/abort_if) [![Coverage Status](https://coveralls.io/repos/github/mooreryan/abort_if/badge.svg?branch=master)](https://coveralls.io/github/mooreryan/abort_if?branch=master)

Simple error logging and assertions for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'abort_if'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abort_if

## Usage

See [documentation](http://www.rubydoc.info/gems/abort_if) for complete
usage.

### Example ###

Here is a tiny example program.

    require "abort_if"

    include AbortIf
    include AbortIf::Assert

    a = 5
    b = 5
    numbers = [1, 2, 3]
    fname = "apple_pie.txt"
    hash = nil

    # this will pass
    assert a == b, "%d should equal %d", a, b

    # this will pass
    abort_unless numbers.include?(1), "numbers should include 1"

    # this will pass
    abort_if_file_exists fname, "#{fname} should not exist"

    File.open(fname, "w") do |f|
      f.puts "Important info to follow...."
    end

    # oops, this will abort the progam and will log a nice message
    # like this
    # F, [2016-03-06T18:14:03.255900 #5357] FATAL -- : the hash was nil
    abort_unless hash, "the hash was nil"

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/mooreryan/abort_if. This project is intended to be
a safe, welcoming space for collaboration, and contributors are
expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of
conduct.
