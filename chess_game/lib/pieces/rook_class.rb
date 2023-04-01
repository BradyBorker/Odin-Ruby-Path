class Rook
  attr_accessor :position, :first_move
  attr_reader :piece, :color

  def initialize(position, color)
    @position = position
    @color = color
    @first_move = true

    color == 'white' ? @piece = "\u2656" : @piece = "\u265C"
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

    return {left: get_left(row, column), right: get_right(row, column), up: get_up(row, column), down: get_down(row, column)}
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
