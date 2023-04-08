class Pawn 
  attr_accessor :position, :has_moved, :forced_move
  attr_reader :piece, :color, :enemy

  @@white_transformations = [[-1, 0], [-1, -1], [-1, 1]]
  @@black_transformations = [[1, 0], [1, -1], [1, 1]]

  def initialize(position, color)
    @position = position
    @color = color
    @has_moved = false
    @forced_move = nil

    color == 'white' ? @piece = " \u2659 " : @piece = " \u265F "
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def get_valid_moves(board_state)
    moves = get_possible_moves()
    valid_moves = prune_moves(board_state, moves)
    return valid_moves
  end

  def get_possible_moves()    
    if @color == 'white'
      @@white_transformations.push([-2, 0]) unless @has_moved
      moves = @@white_transformations.map {|t| [@position[0] + t[0], @position[1] + t[1]]}
      @@white_transformations.pop if @@white_transformations.length > 3
    elsif @color == 'black'
      @@black_transformations.push([2, 0]) unless @has_moved
      moves = @@black_transformations.map {|t| [@position[0] + t[0], @position[1] + t[1]]}
      @@black_transformations.pop if @@black_transformations.length > 3
    end

    moves
  end

  def prune_moves(board_state, moves)    
    pruned_moves = []
    blocked = false
    moves.each do |move|
      next if out_of_bounds?(move)
    
      if move[1] == @position[1]
        if !(board_state[move[0]][move[1]].is_a? String)
          blocked = true
        elsif blocked
          next
        else
          pruned_moves.push(move)
        end

      else
        next if board_state[move[0]][move[1]].is_a? String
        pruned_moves.push(move) if board_state[move[0]][move[1]].color == @enemy
      end
    end

    return pruned_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end