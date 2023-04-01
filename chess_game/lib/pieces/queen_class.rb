class Queen
  attr_accessor :position, :has_moved
  attr_reader :piece, :color

  def initialize(position, color)
    @position = position
    @color = color
    @has_moved = false

    color == 'white' ? @piece = "\u2655" : @piece = "\u265B"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    prune_moves(board_state, moves)
  end

  def get_possible_moves()
    row = @position[0]
    column = @position[1]
    
    bishop = {up_right: get_up_right(row, column), up_left: get_up_left(row, column), down_right: get_down_right(row, column), down_left: get_down_left(row, column)}
    rook = {left: get_left(row, column), right: get_right(row, column), up: get_up(row, column), down: get_down(row, column)}

    bishop.merge(rook)
  end

  def prune_moves(board_state, moves)
    pruned_moves = []
    moves.keys.each do |key|
      moves[key].each do |move|
        tile = board_state[move[0]][move[1]]
        if tile.is_a? String
          pruned_moves.push(move)
        elsif tile.color == @enemy
          pruned_moves.push(move)
          break
        else
          break
        end
      end
    end
    return pruned_moves
  end

  def get_up_right(row, column)
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

  def get_up_left(row, column)
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

  def get_down_right(row, column)
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

  def get_down_left(row, column)
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

  def get_left(row, column)
    possible_moves = []
    column -= 1

    until out_of_bounds?([row, column])
      possible_moves.push([row,column])
      column -= 1
    end

    return possible_moves
  end

  def get_right(row, column)
    possible_moves = []
    column += 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      column += 1
    end

    return possible_moves
  end

  def get_up(row, column)
    possible_moves = []
    row -= 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row -= 1
    end

    return possible_moves
  end

  def get_down(row, column)
    possible_moves = []
    row += 1

    until out_of_bounds?([row, column])
      possible_moves.push([row, column])
      row += 1
    end

    return possible_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end
