# UkAddressParser

Tool to convert a UK address string into its constituent parts.

So for example:

```ruby
UkAddressParser.parse 'Flat 1, Bubble House, 12 Long Road, Someton, Worcestershire, WR1 1XX'
```

Will generate:

    {
      flat: "Flat 1",
      house_number: "12",
      building_name: "Bubble House",
      street: "Long Road",
      street2: nil,
      street3: nil,
      town: "Someton",
      county: "Worcestershire",
      postcode:"WR1 1XX"
    }

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'uk_address_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install uk_address_parser

## Usage Limitations

This parser was initially built to parse a single set of addresses that had a
fairly limited variance in the arrangement of the component parts.

There are some limitations to how it works:

* The parser only works with comma delimited addresses.
* The parser assumes the address is a United Kingdom address and does not search for country

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reggieb/uk_address_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

