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
    moves = get_possible_moves(board_state)
  end

  def get_possible_moves(board_state)
    row = @position[0]
    column = @position[1]

    possible_moves = get_pos_row_pos_col(row, column)
    possible_moves += get_pos_row_neg_col(row, column)
  end

  def get_pos_row_pos_col(row, column)
    possible_moves = []
    row -= 1
    column += 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row -= 1
      column += 1
    end
    
    return possible_moves
  end

  def get_pos_row_neg_col(row, column)
    possible_moves = []
    row -= 1
    column -= 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row -= 1
      column -= 1
    end
    
    return possible_moves
  end
  
  def get_neg_row_pos_col(row, column)
    possible_moves = []
    row += 1
    column += 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row += 1
      column += 1
    end

    return possible_moves
  end

  def get_neg_row_neg_col(row, column)
    possible_moves = []
    row += 1
    column -= 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row += 1
      column -= 1
    end

    return possible_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end