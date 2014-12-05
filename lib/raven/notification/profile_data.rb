class Raven::Notification::ProfileData < Raven::Notification

  def timestamp
    Time.at(Integer(@raw['TimeStamp']) + ZIGBEE_TIME_OFFSET)
  end

  def first_timestamp
    last_timestamp - (@raw['IntervalData'].length - 1) * period_duration
  end

  def last_timestamp
    Time.at(Integer(@raw['EndTime']) + ZIGBEE_TIME_OFFSET)
  end

  def estimated_new_data_available_after
    last_timestamp + period_duration
  end

  def used
    demand = Integer(@raw['CurrentUsage'])
    multiplier = Integer(@raw['Multiplier'])
    divisor = Integer(@raw['Divisor'])

    (Rational(demand * multiplier, divisor) * 1000).round
  end

  def period_duration
    @period_duration ||= case Integer(@raw['ProfileIntervalPeriod'])
    when 0 then 24 * 60 * 60  # or is it "daily" (i.e. DST)
    when 1 then 60 * 60
    when 2 then 30 * 60
    when 3 then 15 * 60
    when 4 then 10 * 60
    when 5 then 15 * 60 / 2  # 7.5 mins
    when 6 then 5 * 60
    when 7 then 5 * 60 / 2   # 2.5 mins
    end
  end

  def data
    timestamp = last_timestamp
    result = []

    @raw['IntervalData'].each do |raw_datum|
      value = Integer(raw_datum)

      result << [timestamp, value]
      timestamp -= period_duration
    end

    Hash[result.reverse]
  end

  def to_s
    [
      "ProfileData: #{first_timestamp} -> #{last_timestamp} #{period_duration}; next data at #{estimated_new_data_available_after}",
      data.map { |timestamp, value| "  #{timestamp}: #{value}Wh" }
    ].flatten.join("\n")
  end

end