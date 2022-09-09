def bubble_sort(array)
  temp_counter = 0
  first_pointer = 0
  switch_count = 0
  while true do
    p array
    temp_counter += 1
    if (temp_counter > 20) then
      break
    end
    
    second_pointer = first_pointer + 1
    
    if (array[first_pointer] > array[second_pointer]) then
      holder_variable = array[first_pointer]
      array[first_pointer] = array[second_pointer]
      array[second_pointer] = holder_variable
    else
      switch_count += 1
    end
    first_pointer += 1
    if (second_pointer == array.length-1 && switch_count > 0) then
      first_pointer = 0
      switch_count = 0
    elsif (second_pointer == array.length-1 && switch_count == 0)
      break
    end
  end
end

bubble_sort([4,3,78,2,0,2])

# Keep pointer of first and second variable
# Look at first pointer, if first pointer is greater then second pointer:
## Swap placement of second pointer with first pointer
# Move first pointer to next index (previously second pointer)
# Move second pointer to next index
# If Second Pointer is pointing at last index
# If a switch as been made
## Loop through list again
# Else if no switch has been made
## Stop looping and return list
