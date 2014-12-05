class Raven::Internal::BasicXmlParser

  class BadInput < RuntimeError; end

  def initialize(stream)
    @stream = stream
  end

  OPENING_MESSAGE_LINE = /\A\<(\w+)\>\z/
  DATA_LINE = /\A\<(\w+)\>([^\<]+)\<\/\1\>\z/

  def next
    message_type = expect_line(OPENING_MESSAGE_LINE)
    finisher = "</#{message_type}>"
    data = {}

    loop do
      data_type, data_value = expect_line(DATA_LINE, finisher)
      break unless data_type

      if data.key?(data_type)
        data[data_type] = [data[data_type]] unless data[data_type].is_a?(Array)
        data[data_type] << data_value
      else
        data[data_type] = data_value
      end
    end

    [message_type, data]
  end

  private

  BLANK = /\A\s*\z/

  def fetch_line
    loop do
      line = @stream.gets
      line.gsub!("\0", '')
      return line.strip unless line =~ BLANK
    end
  end

  def expect_line(matcher, finisher = nil)
    line = fetch_line
    return nil if line == finisher
    raise BadInput.new(line) unless line =~ matcher

    captures = $~.captures

    captures.length > 1 ? captures : captures.first
  end
end