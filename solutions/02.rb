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
    @numbers.each_with_object(NumberSet.new) do |number, filtered_numbers|
      filtered_numbers << number if filter.matches? number
    end
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
    case type
    when :integer then super() { |number| number.is_a? Integer }
    when :real    then super() { |number| number.is_a? Float or
                                          number.is_a? Rational }
    when :complex then super() { |number| number.is_a? Complex }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
    when :positive     then super() { |number| number > 0 }
    when :negative     then super() { |number| number < 0 }
    when :non_positive then super() { |number| number <= 0 }
    when :non_negative then super() { |number| number >= 0}
    end
  end
end