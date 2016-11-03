$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'uk_address_parser'

require 'minitest/autorun'

# Set faker so it uses British formats for postcodes etc.
require "faker"
Faker::Config.locale = "en-GB"
