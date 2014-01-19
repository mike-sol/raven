class Raven::Notification::InstantaneousDemand
  
  def initialize(info)
    @raw = info
  end
  
  def timestamp
    Time.at(Integer(@raw['TimeStamp']) + ZIGBEE_TIME_OFFSET)
  end
  
  def demand
    demand = Integer(@raw['Demand'])
    multiplier = Integer(@raw['Multiplier'])
    divisor = Integer(@raw['Divisor'])
    
    (demand * multiplier).to_f / divisor
  end
  
  def to_s
    "instantaneous demand: #{timestamp.strftime("%H:%M:%S")} #{demand}KW"
  end
  
end