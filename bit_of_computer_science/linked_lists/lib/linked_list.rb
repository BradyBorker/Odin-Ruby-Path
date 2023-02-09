require_relative "node.rb"

class LinkedList
  attr_accessor :head_node

  def initialize()
    @head_node = nil
  end

  def addFirst(value, next_node=nil)
    self.head_node = Node.new(value, next_node)
  end

  def append(value)
    if self.head_node == nil
      addFirst(value)
    else
      current = self.head_node
      current = current.next_node while current.next_node != nil 
      current.next_node = Node.new(value, nil)
    end
  end

  def prepend(value)
    addFirst(value, self.head_node)
  end

  def size()
    current = self.head_node
    node_counter = 0
    while current.next_node != nil do
      node_counter += 1
      current = current.next_node
    end
    return node_counter + 1
  end

  def head()
    return self.head_node.value
  end

  def tail()
    current = self.head_node
    current = current.next_node while current.next_node != nil 
    return current.value
  end

  def at(requested_index)
    current = self.head_node
    current_index = 0
    while current_index < requested_index do
      current = current.next_node
      current_index += 1
    end
    return current.value
  end

  def pop()

  end
end