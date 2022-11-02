class Game
  attr_accessor :hidden_word
  attr_reader :wrong_guesses

  def initialize(word)
    @chosen_word = word
    @hidden_word = '_' * word.length
    @current_guess = ''
    @wrong_guesses = 0
  end

  def self.pick_word(word_list)
    word_list = word_list.split().select {|word| word.length >= 5 && word.length <= 12}
    self.new(word_list.sample)
  end

  def check_guess_against_word(character)
    @current_guess = character
    @indexes = []
    self.chosen_word.split('').each_with_index {|value, index| @indexes.push(index) if value == @current_guess}
    
    if @indexes.empty?
      @wrong_guesses += 1
    end
  end

  def update_hidden_word()
    @indexes.each do |index|
      self.hidden_word[index] = @current_guess
    end
  end

  def check_win()
    if !(self.hidden_word.include?('_'))
      puts "GAME WON"
      return true
    end
  end

  def check_lose()
    if self.wrong_guesses == 7
      puts "GAME LOST"
      return true
    end
  end

  private
  
  attr_reader :chosen_word
end

def display_hangman(wrong_guesses)
  if wrong_guesses == 1
    puts " O"
  elsif wrong_guesses == 2
    puts " O"
    print " |"
  elsif wrong_guesses == 3
    puts " O"
    print "/|"
  elsif wrong_guesses == 4
    puts " O"
    puts "/|\\"
  elsif wrong_guesses == 5
    puts " O"
    puts "/|\\"
    puts "/"
  elsif wrong_guesses == 6
    puts " O"
    puts "/|\\"
    puts "/`\\"
  end
end

def display_menu()
  puts "-" * 35
  puts "            | RULES |"
  puts "Enter a single character (a-z) as guess"
  puts "Type 'exit' to exit game"
  puts "Type 'save' to save game"
  puts "-" * 35
end

def save_game(game_instance)
  Dir.mkdir('saved_games') if !(Dir.exists?('saved_games'))
  saved_game = Marshal.dump(game_instance)
  filename = "saved_games/#{game_instance.hidden_word}-#{Time.now().strftime("%b-%w-%-I:%M%p")}"

  File.open(filename, 'w') do |file|
    file.puts saved_game
  end
  puts "Game Saved!"
end

def load_game()

end

def player_input(game_instance)
  while true
    input = gets.chomp.downcase
    if input.match?(/[[:alpha:]]/) && input.length == 1
      return input.downcase
    elsif input == 'exit'
      puts "Ending Game!"
      return
    elsif input == 'save'
      save_game(game_instance)
    else
      puts "Incorrect Input!"
    end
  end
end

def main(word_list)
  puts "New Game or Load Game?"
  # If new game
  game_instance = Game.pick_word(word_list)
  # TODO: Create game from load file
  display_menu()
  
  puts "    #{game_instance.hidden_word}"
  
  while true
  
    input = player_input(game_instance)
    return if input.nil?

    game_instance.check_guess_against_word(input)
    game_instance.update_hidden_word()

    puts "#{display_hangman(game_instance.wrong_guesses)}    #{game_instance.hidden_word}"

    return if game_instance.check_win() || game_instance.check_lose()
    
    #TODO: Check if game won or lost

    
  end
end

main(File.read('google-10000-english-no-swears.txt'))
