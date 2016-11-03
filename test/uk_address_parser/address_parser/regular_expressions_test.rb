require 'test_helper'
module UkAddressParser
  class RegularExpressionsTest < Minitest::Test

    def test_flat_number
      assert_match_with :flat_number, {
        'Flat 1' => true,
        'Flat 1a' => true,
        'Flat 12' => true,
        'Foo 11' => false,
        'Flat' => false
      }
    end

    def assert_match_with(regex_method, tests)
      tests.each do |string, expected_pass|
        result = address_parser.send(regex_method) =~ string
        expected = expected_pass ? 0 : nil
        msg = "'#{string}' should#{' not' unless expected_pass} match with address_parser.#{regex_method}"
        assert_equal expected, result, msg
      end
    end

    def address_parser
      @address_parser ||= AddressParser.new(address_string)
    end

    def address_string
      @address_string ||= [
        "Flat #{Faker::Number.between(1, 15)}",
        "#{Faker::StarWars.character} #{%w(Hall House Building Appartments).sample}",
        Faker::Address.street_address,
        Faker::Address.city,
        %w(Avon Worcestershire Yorkshire Kent).sample,
        Faker::Address.zip_code
      ].join(address_join)
    end

    def address_join
      @address_join ||= ', '
    end

  end
end
