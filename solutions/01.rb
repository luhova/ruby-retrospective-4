def fibonacci(number)
  number <= 2 ? 1 : fibonacci(number - 1) + fibonacci(number - 2)
end

def lucas(number)
 case number
 when 1 then 2
 when 2 then 1
 else lucas(number - 1) + lucas(number - 2)
 end
end

def series(sequence, number)
  case sequence
  when 'fibonacci' then fibonacci(number)
  when 'lucas'     then lucas(number)
  when 'summed'    then fibonacci(number) + lucas(number)
  end
end