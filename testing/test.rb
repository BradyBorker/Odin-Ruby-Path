lst = [1,2,3,4]

def add_two(lst)
  new_list = []
  lst.each do |num|
    new_list.append(yield(num))
  end
  p new_list
end

add_two(lst) do |num|
  num + 2
end