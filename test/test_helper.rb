$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'uk_address_parser'

require 'minitest/autorun'

class Minitest::Test

  def address_parser
    @address_parser ||= UkAddressParser::AddressParser.new(address_string)
  end

  def address_string
    @address_string ||= address_components.values.join(address_join)
  end

  def address_components
    @address_components ||= {
      flat: flat,
      house_name: house_name,
      number_and_street: Faker::Address.street_address,
      town: Faker::Address.city,
      county: %w(Avon Worcestershire Lancashire Kent).sample,
      postcode: Faker::Address.zip_code
    }
  end

  def flat
    @flat ||= "Flat #{Faker::Number.between(1, 15)}"
  end

  def house_name
    @house_name ||= [
      Faker::StarWars.character,
      %w(Hall House Building Appartments).sample
    ].join(' ')
  end

  def address_join
    @address_join ||= ', '
  end

end

# Set faker so it uses British formats for postcodes etc.
require "faker"
Faker::Config.locale = "en-GB"
