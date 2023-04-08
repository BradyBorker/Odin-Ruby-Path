class Bishop
  attr_accessor :position, :forced_move
  attr_reader :piece, :color, :enemy

  def initialize(position, color)
    @position = position
    @color = color
    @forced_move = nil

    color == 'white' ? @piece = " \u2657 " : @piece = " \u265D "
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    valid_moves = prune_moves(board_state, moves)
    return valid_moves
  end

  def get_possible_moves()
    row = @position[0]
    column = @position[1]

    return {up_right: get_up_right(row, column), up_left: get_up_left(row, column), down_right: get_down_right(row, column), down_left: get_down_left(row, column)}
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

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end