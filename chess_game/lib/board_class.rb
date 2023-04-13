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
    @current_player = @players[0]
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

  def my_piece?(row, column)
    return false if @board[row][column].is_a? String
  
    @board[row][column].color == @current_player.color
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

  def surrounded_by_allies(piece)
    king = @board[@white_king_position[0]][@white_king_position[1]] if piece.color == 'black'
    king = @board[@black_king_position[0]][@black_king_position[1]] if piece.color == 'white'
    possible_moves = king.get_possible_moves

    possible_moves.all? { |move| !@board[move[0]][move[1]].is_a?(String) && @board[move[0]][move[1]].color == king.color }
  end

  def non_king_legal_moves(piece, can_capture_piece, valid_moves)
    king = @board[@white_king_position[0]][@white_king_position[1]] if piece.color == 'white'
    king = @board[@black_king_position[0]][@black_king_position[1]] if piece.color == 'black'
    
    pos = piece.position
    piece.get_valid_moves(@board).each do |move|
      hold_tile = @board[move[0]][move[1]]
      @board[move[0]][move[1]] = piece
      @board[pos[0]][pos[1]] = '   '
      can_capture_piece.each do |enemy_piece|
        if enemy_piece.get_valid_moves(@board).include?(king.position)
          valid_moves -= [move]
          break
        end
      end
      @board[move[0]][move[1]] = hold_tile
      @board[pos[0]][pos[1]] = piece
    end
    valid_moves
  end

  def king_legal_moves(king, valid_moves)
    enemy_pieces = get_enemy_pieces(@board, king.enemy)
    
    pos = king.position
    king.get_valid_moves(@board).each do |move|
      hold_piece = @board[move[0]][move[1]]
      @board[move[0]][move[1]] = king
      @board[pos[0]][pos[1]] = '   '
      enemy_pieces.each do |piece|
        if piece.get_valid_moves(@board).include?(move)
          valid_moves -= [move]
          break
        end
      end
      @board[move[0]][move[1]] = hold_piece
      @board[pos[0]][pos[1]] = king 
    end
    
    valid_moves
  end

  def get_legal_moves(piece)
    valid_moves = piece.get_valid_moves(@board)
    enemy_pieces = []
    @board.each do |row|
      row.each do |column|
        if !column.is_a?(String) && [Rook, Bishop, Queen].include?(column.class) && column.color == piece.enemy
          enemy_pieces.push(column)
        end
      end
    end

    can_capture_piece = []
    enemy_pieces.each do |enemy_piece|
      if enemy_piece.get_valid_moves(@board).include?(piece.position)
        can_capture_piece.push(enemy_piece)
      end
    end

    return valid_moves if can_capture_piece.empty? && piece.class != King
    
    legal_moves = non_king_legal_moves(piece, can_capture_piece, valid_moves) if piece.class != King
    legal_moves = king_legal_moves(piece, valid_moves) if piece.class == King
    
    legal_moves
  end

  def get_enemy_pieces(board, enemy_color)
    enemy_pieces = []
    board.each do |row|
      row.each do |column|
        if !column.is_a?(String) && column.color == enemy_color
          enemy_pieces.push(column)
        end
      end
    end
    enemy_pieces
  end

  def king_escape_possible?(attacking_piece)
    king = @board[@white_king_position[0]][@white_king_position[1]] if attacking_piece.color == 'black'
    king = @board[@black_king_position[0]][@black_king_position[1]] if attacking_piece.color == 'white'
    
    legal_moves = king_legal_moves(king, king.get_valid_moves(@board))

    king.forced_move = legal_moves
    legal_moves.empty? ? false : true
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
    
    possible_defenses.each do |def_piece, moves|
      moves.each do |move|
       if @path_to_check.include?(move)
          check_defeated = true
        def_piece.forced_move = [move]
        end
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

  def no_legal_moves(attacking_piece)
    defending_pieces = get_enemy_pieces(@board, attacking_piece.enemy)

    possible_moves = []
    defending_pieces.each do |def_piece|
      possible_moves += get_legal_moves(def_piece)
    end
    
    possible_moves.empty? ? true : false
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

  def checkmate_or_draw?(piece, current_player)
    in_check = check?(piece)
    puts "#{piece.enemy} King in Check!" if in_check

    remove_forced_moves(piece)
    return 0 if !in_check && surrounded_by_allies(piece)
    
    check_defeated = defeat_check?(piece)
    king_can_escape = king_escape_possible?(piece)
    set_forced_moves(piece) if in_check

    if king_can_escape || check_defeated
      # Continue playing game
      return 0
    elsif in_check && !king_can_escape && !check_defeated
      # Checkmate
      @winner = current_player
      return 1
    elsif !in_check && no_legal_moves(piece)
      # Draw
      return 2
    end
  end

  def game_over?(resolution_code)
    if resolution_code == 0
      false
    elsif resolution_code == 1
      puts "CHECKMATE!"
      puts "#{@winner.name} has WON"
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