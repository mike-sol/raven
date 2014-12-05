class Raven::Notification::CurrentPeriodUsage < Raven::Notification

  def timestamp
    Time.at(Integer(@raw['TimeStamp']) + ZIGBEE_TIME_OFFSET)
  end

  def period_start
    Time.at(Integer(@raw['StartDate']) + ZIGBEE_TIME_OFFSET)
  end

  def used
    demand = Integer(@raw['CurrentUsage'])
    multiplier = Integer(@raw['Multiplier'])
    divisor = Integer(@raw['Divisor'])

    (Rational(demand * multiplier, divisor) * 1000).round
  end

  def to_s
    "CurrentPeriodUsage: #{timestamp.strftime("%Y-%m-%d %H:%M:%S")} #{used}Wh since #{period_start}"
  end

end