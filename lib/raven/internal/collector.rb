class Raven::Internal::Collector < Nokogiri::XML::SAX::Document

  def initialize(processor)
    @stack = []
    @processor = processor
  end

  def start_element(name, attributes = {})
    @stack << [name, attributes]
    
    if @stack.length == 2
      @hash = {}
    elsif @stack.length == 3
      @value = ''
    end
  end
  
  def end_element(name)
    if @stack.length == 2
      @processor.process(name, @hash)
      @hash = nil
    elsif @stack.length == 3
      @hash[name] = @value
      @value = nil
    end

    @stack.pop
  end
  
  def characters(string)
    @value << string if @value
  end

end