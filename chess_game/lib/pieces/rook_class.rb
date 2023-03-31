class Rook
  attr_accessor :position
  attr_reader :piece, :color

  def initialize(position, color)
    @position = position
    @color = color

    color == 'white' ? @piece = "\u2656" : @piece = "\u265C"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    #moves = get_possible_moves()
    #valid_moves = prune_moves(board_state, moves)
    #return valid_moves
  end

  def get_possible_moves()
    next
  end

  def prune_moves()
    next
  end
end