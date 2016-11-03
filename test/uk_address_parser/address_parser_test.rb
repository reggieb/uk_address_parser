require 'test_helper'
module UkAddressParser
  class AddressParserTest < Minitest::Test

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

  end
end
