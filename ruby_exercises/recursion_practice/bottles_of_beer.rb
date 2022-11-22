# My attempt

def bottles_of_beer(n)
  if n <= 0
    puts "no more bottles of beer on the wall"
    return 
  end
  puts "#{n} bottles of beer on the wall"
  bottles_of_beer(n-1)
end

bottles_of_beer(5)

# Answer

def bottles(n)
  if n == 0
    puts "no more bottles of beer on the wall"
  else
    puts "#{n} bottles of beer on the wall"
    bottles(n-1)
  end
end