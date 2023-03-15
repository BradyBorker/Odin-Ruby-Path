class Calculator
  def add(*nums)
    nums.inject {|total, num| total += num}
  end

  def subtract(*nums)
    nums.inject {|total, num| total -= num}
  end

  def multiply(*nums)
    nums.inject {|total, num| total *= num}
  end

  def divide(*nums)
    nums.inject {|total, num| total /= num}
  end
end