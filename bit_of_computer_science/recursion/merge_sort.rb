def merge(b,c)
  arr = []
  b_index = 0
  c_index = 0
  while b_index < b.length && c_index < c.length
    if b[b_index] < c[c_index]
      arr.append(b[b_index])
      b_index += 1
    else  
      arr.append(c[c_index])
      c_index += 1
    end
  end
  if b_index == b.length 
    c[c_index..].each {|num| arr.append(num)}
  elsif c_index == c.length 
    b[b_index..].each {|num| arr.append(num)}
  end
  return arr
end

def merge_sort(arr)
  if arr.length < 2
    return arr
  end
  left_half = arr[0..arr.length/2-1]
  right_half = arr[arr.length/2..]

  left_half = merge_sort(left_half)
  right_half = merge_sort(right_half)
  
  return merge(left_half, right_half)
end

p merge_sort([5,1,3,8,2,7,9,4])

