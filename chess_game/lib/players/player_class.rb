class Player
  attr_reader :name, :color

  @@colors = ['white', 'black']

  def initialize(name)
    @name = name
    @color = @@colors.shift

    announce()
  end

  def self.create_player(chess_banner)
    puts "\e[H\e[2J"
    puts chess_banner

    puts "Enter Name"
    name = gets.chomp
    Player.new(name)
  end

  def announce()
    puts "#{@name} is playing: #{@color}"
    puts ''
  end
end
