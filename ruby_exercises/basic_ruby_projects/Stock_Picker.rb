def stock_picker(days)
  profit_indexes = Array.new(2,0)
  days.each_with_index do |buy_price, buy_index|
    next_day = buy_index + 1
    for day in days[next_day..days.length] do
      if ((day - buy_price) > (days[profit_indexes[1]] - days[profit_indexes[0]])) then
        profit_indexes = [buy_index,next_day] 
      end
      next_day += 1
    end
  end
  return profit_indexes
end

p stock_picker([17,3,6,9,15,8,6,1,10])