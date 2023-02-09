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
    while current.next_node != nil 
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
    while current_index < requested_index
      current = current.next_node
      current_index += 1
    end
    return current.value
  end

  def pop()
    current = self.head_node
    while current.next_node != nil
      previous = current
      current = current.next_node
    end
    previous.next_node = nil
    return current.value
  end

  def contains?(value)
    current = self.head_node
    while current.next_node != nil
      return true if current.value == value
      current = current.next_node
    end
    return true if current.value == value
    return false
  end

  def find(value)
    current = self.head_node
    index = 0
    while current.next_node != nil
      return index if current.value == value
      current = current.next_node
      index += 1
    end
    return index if current.value == value
    return nil
  end

  def to_s()
    current = self.head_node
    string = ""
    while current.next_node != nil
      string += "( #{current.value} ) -> "
      current = current.next_node
    end
    string += "( #{current.value} ) -> nil"
  end

  def insert_at(value, index)
    current = self.head_node
    previous = nil
    current_index = 0

    if index == 0
      addFirst(value, self.head_node)
      return
    end
    
    while current.next_node != nil && current_index != index
      previous = current
      current = current.next_node
      current_index += 1
    end

    previous.next_node = Node.new(value, current)
  end

  def remove_at(index)
    current = self.head_node
    previous = nil
    current_index = 0

    while current.next_node != nil && current_index != index
      previous = current
      current = current.next_node
      current_index += 1
    end

    previous.next_node = current.next_node
  end
end