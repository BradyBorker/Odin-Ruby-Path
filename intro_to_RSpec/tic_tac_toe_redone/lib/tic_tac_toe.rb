require_relative 'board_class'
require_relative 'player_class'

def switch_players(current_player, player1, player2)
    if current_player == player1
        current_player = player2
    else
        current_player = player1
    end
    return current_player
end

player1 = Player.create_player
player2 = Player.create_player
board = Board.new

board.print_board
current_player = player1
loop do
    puts "Current Turn: #{current_player.name}"
    board.make_move(current_player)
    return if board.game_over?(current_player)
    current_player = switch_players(current_player, player1, player2)
end