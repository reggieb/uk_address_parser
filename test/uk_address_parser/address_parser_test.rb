require 'test_helper'
module UkAddressParser
  class AddressParserTest < Minitest::Test

    def test_details
      details = address_parser.details
      assert_equal address_components[:flat], details[:flat]
      assert_equal house_name, details[:house_name]
      assert_equal(
        address_components[:number_and_street].split(' ').first,
        details[:house_number]
      )
      assert_equal(
        address_components[:number_and_street].split(' ')[1..-1].join(' '),
        details[:street]
      )
      assert_equal address_components[:town], details[:town]
      assert_equal address_components[:county], details[:county]
      assert_equal address_components[:postcode], details[:postcode]
    end

    def test_parts
      assert_equal address_components.values, address_parser.parts
    end

    def test_postcode
      assert_equal address_components[:postcode], address_parser.postcode
    end

    def test_postcode_when_absent
      address_components.delete :postcode
      assert_equal nil, address_parser.postcode
    end

    def test_build_county
      address_components.delete :postcode
      assert_equal address_components[:county], address_parser.build_county
    end

    def test_build_county_with_unknown
      address_components.delete :postcode
      address_components[:county] = 'Unknown'
      assert_equal nil, address_parser.build_county
    end

    def test_build_town
      town = Faker::Address.city
      @address_components = {town: town}
      address_parser.build_town
      assert_equal town, address_parser.town
      assert_equal [], address_parser.parts
    end

    def test_streets
      @address_components = {street: 'a', street2: 'b', street3: 'c'}
      address_parser.streets
      assert_equal 'a', address_parser.street
      assert_equal 'b', address_parser.street2
      assert_equal 'c', address_parser.street3
    end

    def test_two_streets
      @address_components = {street: 'a', street2: 'b'}
      address_parser.streets
      assert_equal 'a', address_parser.street
      assert_equal 'b', address_parser.street2
      assert_equal nil, address_parser.street3
    end

    def test_one_streets
      @address_components = {street: 'a'}
      address_parser.streets
      assert_equal 'a', address_parser.street
      assert_equal nil, address_parser.street2
      assert_equal nil, address_parser.street3
    end

    def test_streets_with_existing_street
      @address_components = {street2: 'b', street3: 'c'}
      address_parser.street = 'x'
      address_parser.streets
      assert_equal 'x', address_parser.street
      assert_equal 'b', address_parser.street2
      assert_equal 'c', address_parser.street3
    end

  end
end
