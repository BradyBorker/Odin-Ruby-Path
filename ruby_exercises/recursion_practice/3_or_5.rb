# Uses recursion to find sum of multiples
# of 3 or 5 below 1000

def multiple(upto, counter=1, arr=[])
  if counter == upto
    return arr.reduce {|sum,num| sum += num}
  end
  arr.append(counter) if counter%3==0 || counter%5==0
  multiple(upto, counter+=1, arr)
end

p multiple(1000)