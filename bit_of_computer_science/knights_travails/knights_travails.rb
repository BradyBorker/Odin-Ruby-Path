class Knight
  attr_accessor :position, :parent

  @@TRANSFORMATIONS = [[1,2], [2,1], [-1,2], [-2,1], [-2,-1], [-1,-2], [1,-2], [2,-1]].freeze

  def initialize(position, parent=nil)
    @position = position
    @parent = parent
  end

  def self.transform
    @@TRANSFORMATIONS
  end
end

def is_valid(coordinate)
  if coordinate[0] < 0 || coordinate[1] < 0
    return false
  elsif coordinate[0] > 7 || coordinate[1] > 7
    return false
  else 
    return true
  end
end

def print_path(current)
  path = []
  until current.parent.nil?
    path.unshift(current.position)
    current = current.parent
  end
  path.unshift(current.position)
  
  puts (path.length - 1 > 1) ? "You made it in #{path.length - 1} moves! Here is your path" : "You made it in #{path.length - 1} move! Here is your path"
  
  path.each {|coord| p coord}
end

def knight_moves(start, dest)
  history = []
  coordinates_queue = [Knight.new(start)]

  current = coordinates_queue.shift
  until current.position == dest
    Knight.transform.each do |trans|
      transformed_coord = [trans[0] + current.position[0], trans[1] + current.position[1]]

      coordinates_queue.push(Knight.new(transformed_coord, current)) if is_valid(transformed_coord) && !history.include?(transformed_coord)
      
      history.push(transformed_coord) if is_valid(transformed_coord) && !history.include?(transformed_coord)
    end
    current = coordinates_queue.shift
  end

  print_path(current)
end

knight_moves([0,0], [1,2])
knight_moves([0,0], [3,3])
knight_moves([3,3], [0,0])
knight_moves([3,3], [4,3])