require_relative 'pieces/pawn_class'
require_relative 'pieces/bishop_class'
require_relative 'pieces/knight_class'
require_relative 'pieces/rook_class'
require_relative 'pieces/king_class'
require_relative 'pieces/queen_class'
require 'colorize'

class Board
  attr_reader :board, :players, :current_player
  attr_accessor :white_king_position, :black_king_position

  def initialize(players)
    @pieces = [[Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn],
               [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]]
    @board = build_board(@pieces)
    @white_king_position = [7, 4]
    @black_king_position = [0, 4]
    @path_to_check = []
    @players = players
    @current_player = @players[1]
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

  def switch_players()
    if @current_player == @players[0]
      @current_player = @players[1]
    else
      @current_player = @players[0]
    end
  end

  def on_board(player_input)
    chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
    nums = ['1', '2', '3', '4', '5', '6', '7', '8']
    split_input = player_input.split('')
  
    chars.include?(split_input[0]) && nums.include?(split_input[1])
  end

  def move_piece(piece, first_player_selection, row, column)
    @board[row][column] = piece 
    @board[first_player_selection[0]][first_player_selection[1]] = '   '
    piece.has_moved = true if [Pawn, King, Rook].include?(piece.class)
    update_positions(piece, row, column)
    
    if piece.class == Pawn && (row == 0 || row == 7)
      new_piece = pawn_promotion()
      @board[row][column] = new_piece.new([row, column], piece.color)
    end
    true
  end

  def update_positions(piece, row, column)
    piece.position = [row, column]
  
    if piece.is_a? King
      @white_king_position = [row, column] if piece.color == 'white'
      @black_king_position = [row, column] if piece.color == 'black'
    end
  end

  def pawn_promotion()
    puts "Select a piece to promote pawn to: "
    puts "1. Queen 2. Knight 3. Bishop, 4. Rook "
    choice = gets.chomp
    until ['1','2','3','4'].include?(choice)
      puts "Invalid input"
      choice = gets.chomp
    end

    pieces = [Queen, Knight, Bishop, Rook]
    piece_chosen = pieces[choice.to_i - 1]
  end

  def difference_between_points(first, second)
    Math.sqrt((first[0] - second[0])**2 + (first[1] - second[1])**2).floor
  end

  def mock_board(king_moves, piece)
    mocked_board = Marshal.load(Marshal.dump(@board))
    king_moves.each do |move|
      mocked_board[move[0]][move[1]] = King.new([move[0], move[1]], piece.enemy)
    end
    mocked_board
  end

  def surrounded_by_allies(piece)
    king = @board[@white_king_position[0]][@white_king_position[1]] if piece.color == 'black'
    king = @board[@black_king_position[0]][@black_king_position[1]] if piece.color == 'white'
    possible_moves = king.get_possible_moves

    possible_moves.all? { |move| !@board[move[0]][move[1]].is_a?(String) && @board[move[0]][move[1]].color == king.color }
  end

  def escape_possible?(piece)
    king = @board[@white_king_position[0]][@white_king_position[1]] if piece.color == 'black'
    king = @board[@black_king_position[0]][@black_king_position[1]] if piece.color == 'white'
    valid_moves = king.get_valid_moves(@board)

    possible_attacks = []
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if !tile.is_a?(String) && tile.color == piece.color
          if tile.class == Pawn
            mocked_board = mock_board(valid_moves, piece)
            attacks = tile.get_valid_moves(mocked_board)
          else
            attacks = tile.get_valid_moves(@board)
          end
          possible_attacks += attacks
        end
      end
    end

    new_valid_moves = []
    valid_moves.each do |move|
      new_valid_moves += [move] unless possible_attacks.include?(move)
    end

    king.forced_move = new_valid_moves
    new_valid_moves.empty? ? false : true
  end

  def defeat_check?(piece)
    check_defeated = false
    possible_defenses = {}
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if !tile.is_a?(String) && tile.color == piece.enemy && tile.class != King
          defenses = tile.get_valid_moves(@board)
          possible_defenses[tile] = defenses
        end
      end
    end

    possible_defenses.each do |piece, moves|
      if moves.any? { |move| @path_to_check.include?(move) }
        check_defeated = true
        piece.forced_move = moves
      end
    end
    check_defeated
  end

  def set_forced_moves(piece)
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if !tile.is_a?(String) && tile.color == piece.enemy
          tile.forced_move = [] if tile.forced_move.nil?
        end
      end
    end
  end

  def remove_forced_moves(piece)
    @board.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        tile = @board[row_index][column_index]
        if !tile.is_a?(String) && tile.color == piece.color
          tile.forced_move = nil
        end
      end
    end
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
      until difference_between_points(valid_moves[check_index], piece.position) <= 1
        path_to_check.unshift(valid_moves[check_index])
        check_index -= 1
      end
    end
    path_to_check.unshift(piece.position)
    @path_to_check = path_to_check
    
    in_check
  end

  def checkmate_or_draw?(piece)
    in_check = check?(piece)
    puts "#{piece.enemy} King in Check!" if in_check

    remove_forced_moves(piece)
    return 0 if !in_check && surrounded_by_allies(piece)
    
    check_defeated = defeat_check?(piece)
    king_can_escape = escape_possible?(piece)
    set_forced_moves(piece) if in_check

    if king_can_escape || check_defeated
      # Continue playing game
      return 0
    elsif in_check && !king_can_escape && !check_defeated
      # Checkmate
      return 1
    elsif !in_check && !king_can_escape && !check_defeated
      # Draw
      return 2
    end
  end

  def game_over?(resolution_code, player)
    if resolution_code == 0
      false
    elsif resolution_code == 1
      puts "CHECKMATE!"
      puts "#{player.name} has WON"
      true
    elsif resolution_code == 2
      puts "DRAW"
      true
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