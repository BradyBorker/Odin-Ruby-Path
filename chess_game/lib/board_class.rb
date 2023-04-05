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

  def check?(piece)
    valid_moves = piece.get_valid_moves(@board)
    if piece.color == 'white'
      valid_moves.include?(@black_king_position)
    elsif piece.color == 'black'
      valid_moves.include?(@white_king_position)
    end
  end

  def checkmate?(piece)
    if piece.color == 'white'
      enemy_king = @board[@black_king_position[0]][@black_king_position[1]]
    elsif piece.color == 'black'
      enemy_kingking = @board[@white_king_position[0]][@white_king_position[1]]
    end
    # TODO: Find piece that threatens king. Check to see if any piece can kill it
    #       If not and king cannot move then checkmate.
    enemy_king_valid_moves = enemy_king.get_valid_moves(@board)

    all_possible_allied_moves = {}
    all_possible_enemy_moves = {}
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if !tile.is_a?(String) && tile.color == piece.color
          allied_piece = @board[row_index][column_index]
          all_possible_allied_moves[allied_piece] += allied_piece.get_valid_moves(@board) 
        elsif !tile.is_a?(String) && tile.color == piece.color
          enemy_piece = @board[row_index][column_index]
          all_possible_enemy_moves[enemy_piece] += enemy_piece.get_valid_moves(@board)
        end
      end
    end
    
    

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
end
