require 'test_helper'
module UkAddressParser
  # All of these test, test the method address_parser.building_and_street
  class BuildingAndStreetTest < Minitest::Test

    def test_number_and_known_street_ending
      @address_components = {
        number_and_street: "#{house_number} #{street}"
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal street, address_parser.street
    end

    def test_number_and_known_street_ending_with_building_name
      @address_components = {
        building_name: building_name,
        number_and_street: "#{house_number} #{street}"
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal building_name, address_parser.building_name
      assert_equal street, address_parser.street
    end

    def test_known_street_ending_no_number
      @address_components = { number_and_street: street }
      address_parser.building_and_street
      assert_equal nil, address_parser.house_number
      assert_equal street, address_parser.street
    end

    def test_known_street_ending_no_number_with_building_name
      @address_components = {
        building_name: building_name,
        number_and_street: street
      }
      address_parser.building_and_street
      assert_equal nil, address_parser.house_number
      assert_equal building_name, address_parser.building_name
      assert_equal street, address_parser.street
    end

    def test_flat_number
      @address_components = {
        flat: flat,
        number_and_street: "#{house_number} #{street}"
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal street, address_parser.street
      assert_equal flat, address_parser.flat
    end

    def test_number_and_any_street_name
      street = 'unknown'
      @address_components = {
        number_and_street: "#{house_number} #{street}"
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal street, address_parser.street
    end

    def test_building_name_with_similar_street_with_known_ending
      building_name = 'My Place'
      street = 'Some Place'
      @address_components = {
        building_name: building_name,
        number_and_street: street
      }
      address_parser.building_and_street
      assert_equal building_name, address_parser.building_name
      assert_equal street, address_parser.street
    end

    def test_building_name_with_similar_unknown_ending
      building_name = 'Unknown'
      street = 'Somewhere Unknown'
      @address_components = {
        building_name: building_name,
        number_and_street: "#{house_number} #{street}"
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal building_name, address_parser.building_name
      assert_equal street, address_parser.street
    end

    def test_with_just_building_name
      @address_components = { building_name: building_name }
      address_parser.building_and_street
      assert_equal building_name, address_parser.building_name
      assert_equal nil, address_parser.house_number
      assert_equal nil, address_parser.street
      assert_equal nil, address_parser.flat
    end

    def test_numbered_houser_withing_group_of_buildings_in_street
      building_name = 'Some Cottages'
      street = 'Some Lane'
      numbered_building = "#{house_number} #{building_name}"
      @address_components = {
        building_name: numbered_building,
        street: street
      }
      address_parser.building_and_street
      assert_equal house_number, address_parser.house_number
      assert_equal building_name, address_parser.building_name
      assert_equal street, address_parser.street
    end

    def house_number
      @house_number ||= Faker::Number.between(1, 15).to_s
    end

    def street
      @street ||= Faker::Address.street_name
    end

  end
end
