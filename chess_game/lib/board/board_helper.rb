module Board_Helper
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
    if self.current_player == self.players[0]
      self.current_player = self.players[1]
    else
      self.current_player = self.players[0]
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
  
    self.board[row][column].color == self.current_player.color
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

  def print_board(highlighted=[])
    puts "\e[H\e[2J"
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