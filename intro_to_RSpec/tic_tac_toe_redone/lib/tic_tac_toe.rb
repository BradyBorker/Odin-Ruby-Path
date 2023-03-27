class Board
    attr_reader :spaces_remaining  
    @@win_states = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]

    def initialize()
        @board = ['1','2','3','4','5','6','7','8','9']
        @spaces_remaining = 9
    end

    def make_move(player)
        puts "#{player.name} Select a location between 1 and 9"
        location = gets.chomp().to_i
        until valid_move?(location)
            puts "Invalid input, Needs to be between 1 and 9"
            location = gets.chomp().to_i
        end
        location -= 1

        @board[location] = player.sign
    end

    def valid_move?(input)
        return true if input.between?(1, 9)
    end

    def remove_space()
        @spaces_remaining -= 1
    end

    def game_over?
        return false
    end

    def print_board
        print @board[0] + '|' + @board[1] + '|' + @board[2]
        puts ''
        print '-----'
        puts ''
        print @board[3] + '|' + @board[4] + '|' + @board[5]
        puts ''
        print '-----'
        puts ''
        print @board[6] + '|' + @board[7] + '|' + @board[8]
        puts ''
    end
end

class Player
    attr_reader :name, :sign
    @@signs = ['X', 'O']
    
    def initialize(name)
        @name = name
        @sign = @@signs.shift
    end

    def self.create_player()
        puts "Player name: "
        name = gets.chomp()
        Player.new(name)
    end
end

def play_game()
    player1 = Player.create_player
    player2 = Player.create_player
    board = Board.new

    current_player = player1
    until board.game_over?
        # Announce player
        puts "Current Turn: #{current_player.name}"
        # Make move
        board.make_move(current_player)
        # Check win

        # Switch players
        
        # Print board
    end
end

board = Board.new()
player = Player.new('john')
board.make_move(player)