require 'test_helper'
module UkAddressParser
  class RegularExpressionsTest < Minitest::Test

    def test_number_and_known_street_ending
      assert_match_with :number_and_known_street_ending, {
        '2 Purton Road' => true,
        '2 Purton Rd' => true,
        '10 Downing Street' => true,
        '100 Somewhere Close' => true,
        '4 The Long Street' => true,
        '5 This Place' => true,
        '2 Purton' => false,         # No street ending
        '2 Purton Unknown' => false, # Street ending not known
        'Purton Road' => false       # No number
      }
    end

    def test_known_street_ending_no_number
      assert_match_with :known_street_ending_no_number, {
        'Purton Road' => true,
        'Downing Street' => true,
        'Unknown' => false,
        'Somewhere Unknown' => false,
        '10 Purton Road' => false # With number
      }
    end

    def test_flat_number
      assert_match_with :flat_number, {
        'Flat 1' => true,
        'Flat 1a' => true,
        'Flat 12' => true,
        'Foo 11' => false, # Not starting Flat
        'Flat' => false    # No number
      }
    end

    def test_number_and_any_street_name
      assert_match_with :number_and_any_street_name, {
        '2 Purton Road' => true,
        '2 Purton Rd' => true,
        '10 Downing Street' => true,
        '100 Somewhere Close' => true,
        '4 The Long Street' => true,
        '5 This Place' => true,
        '2 Purton' => true,
        '2 Purton Unknown' => true, 
        'Purton Road' => false       # No number
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
