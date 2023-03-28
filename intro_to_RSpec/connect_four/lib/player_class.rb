class Player
    @@token_colors = [:blue, :red]

    def initialize(name, token_color)
        @name = name
        @token_color = token_color
    end

    def create_player
        puts "Player Name: "
        name = gets.chomp()
        token_color = @@token_colors.shift
        puts "Your color is #{token_color}"
        Player.new(name, token_color)
    end
end