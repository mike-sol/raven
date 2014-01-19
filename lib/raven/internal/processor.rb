class Raven::Internal::Processor
  
  def initialize
  
  end
  
  def process(name, info)
    case name
    when 'InstantaneousDemand'
      puts Raven::Notification::InstantaneousDemand.new(info)
    else
      puts "\e[31m#{name}, #{info.inspect}\e[0m"
    end
  end
  
end