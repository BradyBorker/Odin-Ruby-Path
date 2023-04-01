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
    board = Array.new(8) { Array.new(8) }
    board.each_with_index do |row, row_index|
      piece_list = get_pieces(pieces, row_index)

      row.each_with_index do |column, column_index|
        if row_index.between?(2, 5)
          board[row_index][column_index] = ' '
        else
          piece = piece_list[column_index]
          row_index.between?(0,1) ? color = 'black' : color = 'white'
          board[row_index][column_index] = piece.new([row, column], color)
        end
      end
    end
    board
  end

  def get_pieces(pieces, row_index)
    if row_index == 0
      piece_list = pieces[0]
    elsif row_index == 1
      piece_list = pieces[1]
    elsif row_index == 6
      piece_list = pieces[2]
    elsif row_index == 7
      piece_list = pieces[3]
    end
  end

  def print_board()
    p @board
  end
end

board = Board.new

board.print_board