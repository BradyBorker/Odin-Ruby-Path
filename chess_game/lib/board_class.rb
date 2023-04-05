require_relative 'pieces/pawn_class'
require_relative 'pieces/bishop_class'
require_relative 'pieces/knight_class'
require_relative 'pieces/rook_class'
require_relative 'pieces/king_class'
require_relative 'pieces/queen_class'
require 'colorize'

class Board
  attr_reader :board
  attr_accessor :white_king_position, :black_king_position

  def initialize()
    @pieces = [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]
    @board = build_board(@pieces)
    @white_king_position = [7, 4]
    @black_king_position = [0, 4]
    @path_to_check = []
  end

  def build_board(pieces)
    board = Array.new(8) { Array.new(8) }
    board.each_with_index do |row, row_index|
      piece_list = get_pieces(pieces, row_index)
      row.each_with_index do |column, column_index|
        if row_index.between?(2, 5)
          board[row_index][column_index] = '   '
        else
          piece = piece_list[column_index]
          row_index.between?(0,1) ? color = 'black' : color = 'white'
          board[row_index][column_index] = piece.new([row_index, column_index], color)
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

  def move_piece(piece, first_player_selection, row, column)
    @board[row][column] = piece
    @board[first_player_selection[0]][first_player_selection[1]] = '   '
    piece.has_moved = true if [Pawn, King, Rook].include?(piece.class)
    update_positions(piece, row, column)
  
    print_board
    true
  end

  def update_positions(piece, row, column)
    piece.position = [row, column]
  
    if piece.is_a? King
      @white_king_position = [row, column] if piece.color == 'white'
      @black_king_position = [row, column] if piece.color == 'black'
    end
  end

  def surrounded_by_allies(piece)
    king = @board[@white_king_position[0]][@white_king_position[1]] if piece.color = 'black'
    king = @board[@black_king_position[0]][@black_king_position[1]] if piece.color = 'white'
    possible_moves = king.get_possible_moves

    possible_moves.all? { |move| move.color == piece.color || out_of_bounds?(move) }
  end

  def check?(piece)
    valid_moves = piece.get_valid_moves(@board)
    in_check = false
    path_to_check = []
    check_index = nil

    if piece.color == 'white'
      valid_moves.each_with_index do |move, index|
        if move == @black_king_position
          check_index = index
          in_check = true
        end
      end
    elsif piece.color == 'black'
      valid_moves.each_with_index do |move, index|
        if move == @white_king_position
          check_index = index
          in_check = true
        end
      end
    end

    unless check_index.nil? || [Pawn, King, Knight].include?(piece.class)
      until valid_moves[check_index] == piece.position
        path_to_check.unshift(valid_moves[check_index])
        check_index -= 1
      end
      path_to_check.unshift(piece.position)
    end
    @path_to_check = path_to_check

    in_check
  end

  def checkmate?(piece)
    in_check = board.check?(piece)
    puts "#{piece.enemy} King in Check!" if in_check


  end

  def print_board(highlighted=[])
    @board.each_with_index do |row, row_index|
      print "#{8 - row_index} "

      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if row_index % 2 == 0
          if column_index % 2 == 0
            if highlighted.include?([row_index, column_index])
              print tile.is_a?(String) ? tile.colorize(:black).on_red : tile.piece.colorize(:black).on_red
            else
              print tile.is_a?(String) ? tile.colorize(:black).on_white : tile.piece.colorize(:black).on_white
            end
          else
            if highlighted.include?([row_index, column_index])
              print tile.is_a?(String) ? tile.colorize(:black).on_red : tile.piece.colorize(:black).on_red
            else
              print tile.is_a?(String) ? tile.colorize(:black).on_green : tile.piece.colorize(:black).on_green
            end
          end
        else
          if column_index % 2 == 0
            if highlighted.include?([row_index, column_index])
              print tile.is_a?(String) ? tile.colorize(:black).on_red : tile.piece.colorize(:black).on_red
            else
              print tile.is_a?(String) ? tile.colorize(:black).on_green : tile.piece.colorize(:black).on_green
            end
          else
            if highlighted.include?([row_index, column_index])
              print tile.is_a?(String) ? tile.colorize(:black).on_red : tile.piece.colorize(:black).on_red
            else
              print tile.is_a?(String) ? tile.colorize(:black).on_white : tile.piece.colorize(:black).on_white
            end
          end
        end
      end
      puts ''
    end
    puts "   a  b  c  d  e  f  g  h"
    puts ''
  end

  def out_of_bounds?(move)
    return true if !(move[0].between?(0, 7)) || !(move[1].between?(0, 7))
    false
  end
end
