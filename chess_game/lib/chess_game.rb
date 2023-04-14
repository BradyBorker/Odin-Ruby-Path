require_relative 'board/board_class'
require_relative 'players/player_class'
require_relative 'game_helper/save_load'
require_relative 'game_helper/start_game_menu'

def get_first_input(board, conversions)
  player_input = gets.chomp
  valid_choice = player_choice_menu(player_input, board)
  until valid_choice
    player_input = gets.chomp
    valid_choice = player_choice_menu(player_input, board)
  end

  splitted_input = player_input.split('')
  column = conversions[splitted_input[0].to_sym]
  row = conversions[splitted_input[1].to_sym]

  unless board.my_piece?(row, column)
    puts 'Not your piece, try again'
    return get_first_input(board, conversions)
  end
  [row, column]
end

def get_second_input(board, conversions, moves)
  player_input = gets.chomp
  valid_choice = player_choice_menu(player_input, board)
  until valid_choice
    player_input = gets.chomp
    valid_choice = player_choice_menu(player_input, board)
  end
  splitted_input = player_input.split('')
  column = conversions[splitted_input[0].to_sym]
  row = conversions[splitted_input[1].to_sym]

  if board.my_piece?(row, column) || moves.include?([row, column])
    [row, column]
  else
    puts 'Invalid Selection' unless player_input.downcase == 'save'
    get_second_input(board, conversions, moves)
  end
end

board = start_game()
resolution_code = 0
number_conversion = { '1': 7, '2': 6, '3': 5, '4': 4, '5': 3, '6': 2, '7': 1, '8': 0 }
letter_conversion = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }
conversions = number_conversion.merge(letter_conversion)

until board.game_over?(resolution_code)
  board.print_board
  puts "#{board.current_player.name} Turn:"

  first_player_selection = nil
  move_made = false
  until move_made
    if first_player_selection.nil?
      first_player_selection = get_first_input(board, conversions)
    end
    piece = board.board[first_player_selection[0]][first_player_selection[1]]
    valid_moves = board.get_legal_moves(piece)
    board.print_board(valid_moves)

    second_player_selection = get_second_input(board, conversions, valid_moves)
    row = second_player_selection[0]
    column = second_player_selection[1]
    if board.my_piece?(row, column)
      puts "Piece updated to: #{board.board[row][column].piece}"
      first_player_selection = [row, column]
      next
    end

    move_made = board.move_piece(piece, first_player_selection, row, column)
    first_player_selection = nil
  end

  resolution_code = board.checkmate_or_draw?(piece, board.current_player)
  board.switch_players()
end
