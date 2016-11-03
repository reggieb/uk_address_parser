require "uk_address_parser/version"
require "uk_address_parser/address_parser"

module UkAddressParser
  def self.parse(address)
    AddressParser.new(address).details
  end
end
