class Pawn 
  attr_accessor :position, :first_move
  attr_reader :piece, :color

  @@white_transformations = [[-1, 0], [-1, -1], [-1, 1]]
  @@black_transformations = [[1, 0], [1, -1], [1, 1]]

  def initialize(position, color)
    @position = position
    @color = color
    @first_move = true

    color == 'white' ? @piece = "\u2659" : @piece = "\u265F"
    color == 'white' ? @enemy = 'black' : @enemy = 'white'
  end

  def move(board_state)
      moves = get_available_moves()
      pruned_moves = prune_moves(board_state, moves)
  end

  def get_available_moves()    
    if @color == 'white'
      moves = @@white_transformations.map {|t| [@position[0] + t[0], @position[1] + t[1]]}
    elsif @color == 'black'
      moves = @@black_transformations.map {|t| [@position[0] + t[0], @position[1] + t[1]]}
    end

    return moves
  end

  def prune_moves(board_state, moves)
    pruned_moves = []
    moves.each_with_index do |move, index|
      next if out_of_bounds?(move)

      if index == 0
        pruned_moves.push(move) if board_state[move[0]][move[1]] == ' '
      elsif index >= 1
        next if board_state[move[0]][move[1]] == ' '
        pruned_moves.push(move) if board_state[move[0]][move[1]].color == @enemy
      end
    end

    pruned_moves
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end