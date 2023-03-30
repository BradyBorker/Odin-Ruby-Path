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
    valid_moves = prune_moves(board_state, moves)
    return valid_moves
  end

  def get_possible_moves()
    possible_moves = []
    Knight.transformations.each do |trans|
      move = [trans[0] + @position[0], trans[1] + @position[1]]
      possible_moves.push(move) if !(out_of_bounds?(move))
    end
    return possible_moves
  end

  def prune_moves(board_state, moves)
    pruned_moves = []
    moves.each do |move|
      tile = board_state[move[0]][move[1]]
      pruned_moves.push(move) if tile.is_a?(String) || tile.color == @enemy
    end
    return pruned_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end