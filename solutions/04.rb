module UI
  class TextScreen
    def self.draw(&block)
      Proxy.new.instance_eval(&block)
    end
  end

  class Proxy
    attr_accessor :message, :arr
    def initialize
      @message = ""
      @arr = []
    end
    def label(text:, border: nil, style: nil)
      @message = "#{text}"
      @message = "#{text}".upcase   if "#{style}" == "upcase"
      @message = "#{text}".downcase if "#{style}" == "downcase"
      @message = "#{border}" + @message + "#{border}" if border
      @arr << @message
      @arr.join
    end

    def vertical(style: nil, border: nil, &block)
      block.call(self)
      @arr.join("\n")
    end
  end
end