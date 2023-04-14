
def start_game()
  chess_banner = File.read('/Users/brady.barker/repos/Odin-Ruby-Path/chess_game/lib/game_helper/chess_banner.txt')

  puts "\e[H\e[2J"
  puts chess_banner

  puts 'Welcome to Chess game!'
  puts 'Load Game or New Game: '
  puts '1. New Game'
  puts '2. Load Game'
  new_or_load = gets.chomp
  until new_or_load.ord.between?(49, 50)
    puts 'Input needs to be 1 or 2'
    new_or_load = gets.chomp
  end

  return load_game() if new_or_load == '2'

  puts "\e[H\e[2J"
  puts chess_banner

  puts 'Game Type:'
  puts '1. Player vs. Player'
  puts '2. Player vs. Computer'
  gametype = gets.chomp
  until gametype.ord.between?(49, 50)
    puts 'Input needs to be 1 or 2'
    gametype = gets.chomp
  end

  puts "\e[H\e[2J"
  puts chess_banner

  puts "Type 'save' to save"
  puts "Type 'exit' to exit"
  puts "Press enter to continue"
  input = gets.chomp()
  until input == ""
    input = gets.chomp()
  end

  return Board.new([Player.create_player(chess_banner), Player.create_player(chess_banner)]) if gametype == '1'
  return Board.new([Player.create_player(chess_banner), Player.new('Computer')]) if gametype == '2'
end

def player_choice_menu(player_choice, board, moves=[])
  puts "\e[H\e[2J"
  puts board.print_board(moves)
  
  if player_choice == 'save'
    save_game(board)
  elsif player_choice == 'exit'
    exit
  else
    if board.on_board(player_choice)
      true
    else
      puts 'Invalid Input'
      false
    end
  end
end