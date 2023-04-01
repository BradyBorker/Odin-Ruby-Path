attr_accessor :position, :first_move
  attr_reader :piece, :color

  def initialize(position, color)
    @position = position
    @color = color
    @first_move = true

    color == 'white' ? @piece = "\u2654" : @piece = "\u265A"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    prune_moves(board_state, moves)
  end

  def get_possible_moves()
    return 0
  end

  def prune_moves(board_state, moves)
    return 0
  end
end