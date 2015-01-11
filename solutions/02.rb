class NumberSet
  include Enumerable

  def initialize
    @numbers = []
  end

  def each(&block)
    @numbers.each(&block)
  end

  def <<(number)
    @numbers << number unless @numbers.include?(number)
  end

  def size
    @numbers.size
  end

  def empty?
    @numbers.empty?
  end

  def [](filter)
    filtered_numbers = NumberSet.new
    array = @numbers.select { |number| filter.matches? number }
    array.each { |number| filtered_numbers << number }
    filtered_numbers
  end
end

class Filter
  def initialize(&block)
    @filter = block
  end

  def matches?(numbers)
    @filter.(numbers)
  end

  def |(filter)
    Filter.new { |number| matches? number or filter.matches? number }
  end

  def &(filter)
    Filter.new { |number| matches? number and filter.matches? number }
  end
end

class TypeFilter < Filter
  def initialize(type)
    if type == :integer
      @filter = super() { |number| number.is_a? Integer }
    elsif type == :real
      @filter = super() { |number| number.is_a? Rational or number.is_a? Float}
    else
      @filter = super() { |number| number.is_a? Complex }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case
      when sign == :positive
        @filter = super() { |number| number > 0 }
      when sign == :non_positive
        @filter = super { |number| number <= 0 }
      when sign == :negative
        @filter = super() { |number| number < 0 }
      when sign == :non_negative
        @filter = super() { |number| number >= 0 }
    end
  end
end