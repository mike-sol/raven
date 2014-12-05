class Raven::Device

  def initialize(stream)
    @stream = stream
    @processor = Raven::Internal::Processor.new
    @parser = Nokogiri::XML::SAX::PushParser.new(Raven::Internal::Collector.new(@processor))
    @parser << "<Stream>"
  end

  def run!(&block)
    saved_block = @processor.block
    @processor.block = block

    while true
      line = @stream.gets
      line.gsub!("\0", '')   # seems to send through a bunch of nulls
      
      puts "LINE: #{line.inspect}"
      @parser << line
    end
  ensure
    @processor.block = saved_block
  end

  def run_until!(notification_klass)
    run! do |notification|
      return notification if notification.is_a?(notification_klass)
      puts "ignoring: #{notification}"
    end
  end

  def finish!    
    @parser << "</Stream>"
    @parser.finish
  end

  def get_time!
    @stream << "<Command><Name>get_time</Name></Command>"
    true
  end

  def get_time
    get_time!
    run_until! Raven::Notification::TimeCluster
  end

end