require_relative "lib/linked_list.rb"

list = LinkedList.new()

list.append(5)
list.append(4)
list.append(3)
list.prepend(10)
list.prepend(12)

p list.to_s

p list.size

p list.head

p list.tail

p list.at(1)

p list.pop
p list.to_s

p list.contains?(4)
p list.contains?(100)

p list.find(4)

list.insert_at(25, 1)
p list.to_s

list.remove_at(1)
p list.to_s