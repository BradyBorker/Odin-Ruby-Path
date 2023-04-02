require_relative 'board_class'
require_relative 'player_class'

def welcome_banner
  puts 'Welcome to Chess game!'
  puts 'Game Type:'
  puts '1. Player vs. Player'
  puts '2. Player vs. Computer'

  choice = gets.chomp
  until choice.ord == 49 || choice.ord == 50
    puts 'Invaid Input'
    puts 'Needs to be 1 or 2'
    choice = gets.chomp
  end
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

board = Board.new
players = create_players(welcome_banner())
current_player = players[1]
loop do
  current_player = switch_players(players, current_player)
  board.print_board
  puts ''
  puts "#{current_player.name} turn"
  puts ''
  break
end
