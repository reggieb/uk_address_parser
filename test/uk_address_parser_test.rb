require 'test_helper'

class UkAddressParserTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::UkAddressParser::VERSION
  end

  def test_parse
    address = 'Flat 1, Bubble House, 12 Long Road, Someton, Worcestershire, WR1 1XX'
    expected = {
      flat: "Flat 1",
      house_number: "12",
      house_name: "Bubble House",
      street: "Long Road",
      street2: nil,
      street3: nil,
      town: "Someton",
      county: "Worcestershire",
      postcode:"WR1 1XX"
    }
    assert_equal expected, UkAddressParser.parse(address)
  end
end
