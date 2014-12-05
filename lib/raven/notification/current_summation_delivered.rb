class Raven::Notification::CurrentSummationDelivered < Raven::Notification

  def timestamp
    Time.at(Integer(@raw['TimeStamp']) + ZIGBEE_TIME_OFFSET)
  end

  def delivered
    demand = Integer(@raw['SummationDelivered'])
    multiplier = Integer(@raw['Multiplier'])
    divisor = Integer(@raw['Divisor'])

    (Rational(demand * multiplier, divisor) * 1000).round
  end

  def to_s
    "CurrentSummationDelivered: #{timestamp.strftime("%Y-%m-%d %H:%M:%S")} #{delivered}Wh"
  end

end