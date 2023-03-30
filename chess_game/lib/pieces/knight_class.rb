class Knight
  attr_accessor :position
  attr_reader :piece, :color

  @@TRANSFORMATIONS = [[1,2], [2,1], [-1,2], [-2,1], [-2,-1], [-1,-2], [1,-2], [2,-1]].freeze

  def initialize(position, color)
    @position = position
    @color = color

    color == 'white' ? @piece = "\u2657" : @piece = "\u265D"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def self.transformations 
    @@TRANSFORMATIONS
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    #valid_moves = pruned_moves(board_state, moves)
    #return valid_moves
  end

  def get_possible_moves()
    possible_moves = []
    Knight.transformations.each do |trans|
      possible_moves.push([@position[0] + trans[0], @position[1] + trans[1]])
    end
    return possible_moves
  end
end