class Player
    @@token_colors = [:blue, :red]

    attr_reader :name, :token
    def initialize(name, token_color)
        @name = name
        @token = 'O'.colorize(token_color)
    end

    def self.create_player
        puts "Enter Player Name: "
        name = gets.chomp()
        token_color = @@token_colors.shift
        puts "Your color is #{token_color}"
        Player.new(name, token_color)
    end
end