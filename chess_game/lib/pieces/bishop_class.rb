class Bishop
  attr_accessor :position
  attr_reader :piece, :color

  def initialize(position, color)
    @position = position
    @color = color

    color == 'white' ? @piece = "\u2657" : @piece = "\u265D"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_available_moves(board_state)
  end

  def get_available_moves(board_state)

  end
end