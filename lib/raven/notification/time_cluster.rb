class Raven::Notification::TimeCluster < Raven::Notification

  def utc_time
    Time.at(Integer(@raw['UTCTime']) + ZIGBEE_TIME_OFFSET).utc
  end

  def to_s
    "TimeCluster: #{utc_time.strftime("%H:%M:%S")}"
  end

end