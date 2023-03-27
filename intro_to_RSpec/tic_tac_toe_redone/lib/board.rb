class Board
    attr_reader :spaces_remaining  
    @@win_states = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]

    def initialize()
        @board = ['1','2','3','4','5','6','7','8','9']
        @spaces_remaining = 9
    end

    def make_move(player)
        puts "#{player.name} select a location between 1 and 9"
        location = gets.chomp().to_i - 1
        until valid_move?(location)
            puts "Invalid input: Needs to be between 1 and 9 and empty"
            location = gets.chomp().to_i - 1
        end

        @board[location] = player.sign
        @spaces_remaining -= 1
        print_board()
    end

    def valid_move?(input)
        return true if input.between?(0, 8) && (@board[input] != 'X' && @board[input] != 'O')
    end

    def game_over?(player)
        @@win_states.each do |win_state|
            count = 0
            win_state.each do |coord|
                if @board[coord] == player.sign
                    count += 1
                end

                if count == 3
                    puts "#{player.name} WINS!"
                    return true
                end
            end
        end

        if @spaces_remaining == 0
            puts "IT IS A TIE!"
            return true
        end

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

    private
    attr_reader :win_states
end