def stock_picker(days)
  # buy date and sell date
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

#First Step: Grab buy date
#Using buy date go down all numbers that come after buy date
#Find total profit of each number:
##Sell Date - Buy Date
##Save in profit variable
#Test profit with new profit, if higher replace profit
#Return the indexes of the Buy and Sell Date