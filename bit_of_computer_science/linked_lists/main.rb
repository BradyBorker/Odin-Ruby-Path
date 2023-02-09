require_relative "lib/linked_list.rb"

list = LinkedList.new()

list.append(5)
list.append(4)
list.append(3)
list.prepend(10)
list.prepend(12)

p list
p list.size
p list.head
p list.tail
p list.at(3) 
