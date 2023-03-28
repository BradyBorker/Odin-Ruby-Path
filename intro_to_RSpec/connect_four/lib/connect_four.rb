require_relative 'player_class.rb'
require_relative 'rack_class.rb'
require 'colorize'

def switch_players(current_player, player1, player2)
    if current_player == player1
        current_player = player2
    else
        current_player = player1
    end
end

player1 = Player.create_player
player2 = Player.create_player
game = Rack.new
game.print_board

current_player = player1
loop do
    puts "Select a column to place a token"
    column = gets.chomp().to_i - 1
    until game.place_token(current_player, column)
        puts "Invalid Column Selected"
        column = gets.chomp().to_i - 1
    end
    current_player = switch_players(current_player, player1, player2)
    game.print_board
end
