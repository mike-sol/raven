require 'nokogiri'

module Raven
end

ZIGBEE_TIME_OFFSET = Time.utc(2000, 1, 1).to_i

require_relative 'raven/notification'
require_relative 'raven/internal'
require_relative 'raven/device'