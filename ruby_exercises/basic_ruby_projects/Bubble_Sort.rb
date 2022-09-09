def bubble_sort(array)
  first_pointer = 0
  has_switched = false
  while true do
    second_pointer = first_pointer + 1
    
    if (array[first_pointer] > array[second_pointer]) then
      holder_variable = array[first_pointer]
      array[first_pointer] = array[second_pointer]
      array[second_pointer] = holder_variable
      has_switched = true
    end

    first_pointer += 1
    if (second_pointer == array.length-1 && has_switched) then
      first_pointer = 0
      has_switched = false
    elsif (second_pointer == array.length-1 && !has_switched)
      break
    end
  end
  return array
end

p bubble_sort([4,3,78,2,0,2])