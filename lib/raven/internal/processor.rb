class Raven::Internal::Processor
  attr_accessor :block

  def initialize
    @block = nil
  end
  
  def process(name, info)
    return unless @block

    case name
    when 'InstantaneousDemand'
      block.call Raven::Notification::InstantaneousDemand.new(info)
    when 'TimeCluster'
      block.call Raven::Notification::TimeCluster.new(info)
    else
      puts "\e[31m#{name}, #{info.inspect}\e[0m"
    end
  end
  
end