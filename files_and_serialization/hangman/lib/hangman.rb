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

def save_game(game_instance)
  Dir.mkdir('saved_games') if !(Dir.exists?('saved_games'))
  saved_game = Marshal.dump(game_instance)
  filename = "saved_games/#{game_instance.hidden_word}-#{Time.now().strftime("%b-%w-%-I:%M%p")}"

  File.open(filename, 'w') do |file|
    file.puts saved_game
  end
  puts "Game Saved!"
end

def load_game(word_list)
  counter = 1
  game_files = {}
  Dir.each_child("saved_games") do |game|
    game_files[counter] = game 
    counter += 1
  end

  puts "Pick a game to load (Enter a number)"
  puts "-" * 20
  game_files.each_pair do |number, game|
    puts "#{number}    #{game}"
  end
  puts "-" * 20

  while true
    input = gets.chomp.to_i
    if game_files.keys.include?(input)
      File.open("saved_games/#{game_files[input]}") do |file|
        loaded_instance = Marshal.load(file.read)
        file.close
        return loaded_instance
      end
    else
      puts "Not an option, try again"
    end
  end
end

def start_game(word_list)
  if !(Dir.exists?("saved_games")) || Dir.empty?("saved_games")
    puts "Starting new game!"
    return Game.pick_word(word_list)
  end

  puts "New Game or Load Game?"
  puts "type 'new' for new game and 'load' for saved game"
  while true
    input = gets.chomp.downcase
    if input == 'new'
      return Game.pick_word(word_list)
    elsif input == 'load'
      return load_game(word_list)
    else
      puts "Wrong Input"
    end
  end
end

def main(word_list)
  # If new game
  #game_instance = Game.pick_word(word_list)
  game_instance = start_game(word_list)

  display_menu()
  display_hangman(game_instance.wrong_guesses)

  puts "    #{game_instance.hidden_word}"
  
  while true
    input = player_input(game_instance)
    return if input.nil?

    game_instance.check_guess_against_word(input)
    game_instance.update_hidden_word()

    puts "#{display_hangman(game_instance.wrong_guesses)}    #{game_instance.hidden_word}"

    return if game_instance.check_win() || game_instance.check_lose()
  end
end

main(File.read('google-10000-english-no-swears.txt'))
