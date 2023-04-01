require_relative 'pieces/pawn_class'
require_relative 'pieces/bishop_class'
require_relative 'pieces/knight_class'
require_relative 'pieces/rook_class'
require_relative 'pieces/king_class'
require_relative 'pieces/queen_class'

class Board
  def initialize()
    @pieces = [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]
    @board = build_board(@pieces)
  end

  def build_board(pieces)
    return 0
  end
end
