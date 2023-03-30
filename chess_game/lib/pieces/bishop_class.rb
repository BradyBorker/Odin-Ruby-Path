class Bishop
  def initialize(position, color)
    @position = position
    @color = color

    color == 'white' ? @piece = "\u2657" : @piece = "\u265D"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def move(board_state)
    moves = get_available_moves()
  end

  def get_available_moves()

  end
end