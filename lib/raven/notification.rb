class Raven::Notification

  def initialize(message_type, message_data)
    @message_type = message_type
    @raw = message_data
  end

  def self.build(message_type, message_data)
    klass_name = Raven::Notification.constants.detect { |m| m.to_s == message_type }
    return new(message_type, message_data) unless klass_name
    Raven::Notification.const_get(klass_name).new(message_type, message_data)
  end

  def to_s
    "#{@message_type}: #{@raw.inspect}"
  end

end

require_relative 'notification/current_period_usage'
require_relative 'notification/current_summation_delivered'
require_relative 'notification/instantaneous_demand'
require_relative 'notification/profile_data'
require_relative 'notification/time_cluster'