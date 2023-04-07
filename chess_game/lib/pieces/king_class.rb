class King
  attr_accessor :position, :has_moved
  attr_reader :piece, :color, :enemy

  @@TRANSFORMATIONS = [[-1,0], [1,0], [0,-1], [0,1], [-1,1], [-1,-1], [1,1], [1,-1]]

  def initialize(position, color)
    @position = position
    @color = color
    @has_moved = false
    @forced_move = []

    color == 'white' ? @piece = " \u2654 " : @piece = " \u265A "
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    prune_moves(board_state, moves)
  end

  def get_possible_moves()
    possible_moves = []
    @@TRANSFORMATIONS.each do |trans|
      move = [trans[0] + @position[0], trans[1] + @position[1]]
      possible_moves.push(move) unless out_of_bounds?(move)
    end
    possible_moves
  end

  def prune_moves(board_state, moves)
    pruned_moves = []
    moves.each do |move|
      tile = board_state[move[0]][move[1]]
      pruned_moves.push(move) if tile.is_a?(String) || tile.color == @enemy
    end
    pruned_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end