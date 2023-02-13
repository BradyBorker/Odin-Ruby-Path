class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data
  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
  end

  def build_tree(array)
    if array.length < 1
      return
    end

    root_node = Node.new(array[array.length / 2])

    root_node.left = build_tree(array[0...array.length / 2])

    root_node.right = build_tree(array[array.length / 2 + 1..])

    return root_node
  end

  def insert(value)
    current_node = self.root

    while current_node.left != nil || current_node.right != nil
      if value < current_node.data
        if current_node.left.nil?
          current_node.left = Node.new(value)
          return
        end
        current_node = current_node.left
      else
        if current_node.right.nil?
          current_node.right = Node.new(value)
          return
        end
        current_node = current_node.right
      end
    end

    if value < current_node.data 
      current_node.left = Node.new(value)
    else
      current_node.right = Node.new(value)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

tree.insert(30)
tree.insert(37)
tree.insert(2)
tree.insert(40)
tree.insert(17)

tree.pretty_print
