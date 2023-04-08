require_relative 'board_class'
require_relative 'player_class'

def welcome_banner
  puts 'Welcome to Chess game!'
  puts 'Game Type:'
  puts '1. Player vs. Player'
  puts '2. Player vs. Computer'

  choice = gets.chomp
  until choice.ord.between?(49, 50)
    puts 'Input needs to be 1 or 2'
    choice = gets.chomp
  end
  puts ''
  choice.to_i
end

def create_players(choice)
  if choice == 1
    player1 = Player.create_player
    player2 = Player.create_player
  elsif choice == 2
    player1 = Player.create_player
    player2 = Player.new('Computer')
  end
  [player1, player2]
end

def switch_players(players, current_player)
  if current_player == players[0]
    current_player = players[1]
  elsif current_player == players[1]
    current_player = players[0]
  else
    current_player = players[0]
  end
  current_player
end

def on_board(player_input)
  chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
  nums = ['1', '2', '3', '4', '5', '6', '7', '8']
  split_input = player_input.split('')

  chars.include?(split_input[0]) && nums.include?(split_input[1])
end

def my_piece?(row, column, board, player)
  return false if board[row][column].is_a? String

  board[row][column].color == player.color
end

def get_first_input(player, board, conversions)
  player_input = gets.chomp
  until on_board(player_input)
    puts 'Invalid input'
    player_input = gets.chomp
  end
  splitted_input = player_input.split('')

  column = conversions[splitted_input[0].to_sym]
  row = conversions[splitted_input[1].to_sym]

  unless my_piece?(row, column, board, player)
    puts 'Invalid input'
    return get_first_input(player, board, conversions) 
  end
  [row, column]
end

def get_second_input(player, board, conversions, moves)
  player_input = gets.chomp
  until on_board(player_input)
    puts 'Invalid Input'
    player_input = gets.chomp
  end
  splitted_input = player_input.split('')

  column = conversions[splitted_input[0].to_sym]
  row = conversions[splitted_input[1].to_sym]

  if my_piece?(row, column, board, player) || moves.include?([row, column])
    [row, column]
  else
    puts 'Invalid Selection'
    get_second_input(player, board, conversions, moves)
  end
end

board = Board.new
players = create_players(welcome_banner())
current_player = players[1]
resolution_code = 0
number_conversion = { '1': 7, '2': 6, '3': 5, '4': 4, '5': 3, '6': 2, '7': 1, '8': 0 }
letter_conversion = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }
conversions = number_conversion.merge(letter_conversion)

until board.game_over?(resolution_code, current_player)
  current_player = switch_players(players, current_player)
  board.print_board
  puts "#{current_player.name} Turn:"

  first_player_selection = nil
  move_made = false
  until move_made
    if first_player_selection.nil?
      first_player_selection = get_first_input(current_player, board.board, conversions)
    end
    piece = board.board[first_player_selection[0]][first_player_selection[1]]
    valid_moves = piece.get_valid_moves(board.board)
    board.print_board(valid_moves)

    second_player_selection = get_second_input(current_player, board.board, conversions, valid_moves)
    row = second_player_selection[0]
    column = second_player_selection[1]
    if my_piece?(row, column, board.board, current_player)
      puts "Piece updated to: #{board.board[row][column].piece}"
      first_player_selection = [row, column]
      next
    end

    move_made = board.move_piece(piece, first_player_selection, row, column)
    first_player_selection = nil
  end

  resolution_code = board.checkmate_or_draw?(piece)
end
