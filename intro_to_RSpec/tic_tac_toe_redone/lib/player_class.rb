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