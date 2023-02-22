class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data, :node_height
  def initialize(array)
    @data = array.sort.uniq
    @root = build_tree(data)
    @node_height = 0
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

  def insert(value, root=self.root)
    if root == nil
      return Node.new(value)
    end

    if value < root.data
      root.left = insert(value, root.left)
    elsif value > root.data
      root.right = insert(value, root.right)
    end

    return root
  end

  def min_value_node(node)
    current = node

    while !current.left.nil?
      current = current.left
    end

    return current
  end

  def delete(value, root=self.root)
    if root.nil?
      return root
    end
    if value < root.data
      root.left = delete(value, root.left)
    elsif value > root.data
      root.right = delete(value, root.right)
    else
      if root.right.nil?
        temp = root.left
        root = nil
        return temp
      elsif root.left.nil?
        temp = root.right
        root = nil
        return temp
      end

      temp = min_value_node(root.right)

      root.data = temp.data

      root.right = delete(temp.data, root.right)
    end

    return root
  end

  def find(value, root=self.root)
    current = root

    while !current.nil?
      if value < current.data
        current = current.left
      elsif value > current.data
        current = current.right
      else
        return current
      end
    end
  end

  def level_order()
    current = self.root
    queue = [current]
    nodes = []

    while queue.length > 0
      current = queue.shift
      
      queue.push(current.left) if !current.left.nil?
      queue.push(current.right) if !current.right.nil?

      block_given? ? (yield current) : nodes.push(current.data)
    end
    
    return nodes if !block_given?
  end

  def preorder(root=self.root, nodes=[])
    return if root.nil?
    
    nodes.push(root)
    preorder(root.left, nodes)
    preorder(root.right, nodes)

    if block_given?
      nodes.each {|node| yield node}
      return
    else
      return nodes.map {|node| node.data}
    end 
  end

  def inorder(root=self.root, nodes=[])
    return if root.nil?
    
    inorder(root.left, nodes)
    nodes.push(root)
    inorder(root.right, nodes)
    
    if block_given?
      nodes.each {|node| yield node}
      return
    else
      return nodes.map {|node| node.data}
    end 
  end 

  def postorder(root=self.root, nodes=[])
    return if root.nil?

    postorder(root.left, nodes)
    postorder(root.right, nodes)
    nodes.push(root)

    if block_given?
      nodes.each {|node| yield node}
      return
    else
      return nodes.map {|node| node.data}
    end
  end

  def tree_height(target=self.root.data, root=self.root)
    if root.nil?
      return -1
    end

    left_height = tree_height(target, root.left)
    right_height = tree_height(target, root.right)

    ans = [left_height, right_height].max + 1 

    if root.data == target
      self.node_height = ans
    end

    return ans
  end

  def height(target)
    max_height = tree_height(target)
    return self.node_height
  end

  def depth(target, root=self.root, d=0)
    if root.nil?
      return -1
    elsif root.data == target
      return d 
    end

    if target < root.data
      depth(target, root.left, d + 1)
    else
      depth(target, root.right, d + 1)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

tree.insert(6400)
tree.insert(360)
tree.insert(250)
tree.insert(6500)
tree.insert(6375)
tree.delete(1)
tree.delete(7)
tree.delete(324)
#tree.find(9)
#tree.level_order
#puts 'postorder'
#p tree.postorder
#p tree.height(67)
p tree.depth(5)

tree.pretty_print
