=begin
def rock_judger(rocks_arr)
  if rocks_arr.length <= 2
    a = rocks_arr[0]
    b = rocks_arr[-1]
  else
    a = rock_judger(rocks_arr.slice!(0,rocks_arr.length/2))
    b = rock_judger(rocks_arr)
  end

  return a > b ? a : b
end

rocks = 30.times.map{rand(200) + 1}
=end

