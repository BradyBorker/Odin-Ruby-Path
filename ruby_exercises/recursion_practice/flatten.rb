# My attempt

def flatten(arr, flattened=[])
  for num in arr
    if num.class == Array
      flatten(num, flattened)
    else
      flattened.append(num)
    end
  end
  return flattened
end

p flatten([[1,2],[3,4]])
p flatten([[1, [8, 9]], [3, 4]]) 

# Answer

def flatten(array, result = [])
  array.each do |element|
    if element.kind_of?(Array)
      flatten(element, result)
    else
      result << element 
    end
  end
  result 
end

