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

  def check_char_against_word(character)
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

  protected
  
  attr_reader :chosen_word
end

def make_guess()
  while true
    guess = gets.chomp
    if guess.match?(/[[:alpha:]]/) && guess.length == 1
      return guess.downcase
    else
      puts "Incorrect Input!"
    end
  end
end

def display_hangman(wrong_guesses)
  if wrong_guesses == 1
    puts " O"
  elsif wrong_guesses == 2
    puts " O"
    print "|"
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
    puts "/\\"
  end
end

def main(word_list)
  # If new game
  game_instance = Game.pick_word(word_list)
  #game_instance = Game.pick_word('app')
  # TODO: Create game from load file
  puts "Make a guess... Can only pick one character!"
  puts game_instance.hidden_word
  
  while true
  
    guess = make_guess()
    game_instance.check_char_against_word(guess)
    game_instance.update_hidden_word()

    puts "#{display_hangman(game_instance.wrong_guesses)}    #{game_instance.hidden_word}"

    #puts game_instance.hidden_word

    #display_hangman(game_instance.wrong_guesses)

    return if game_instance.check_win() || game_instance.check_lose()
    
    #TODO: Check if game won or lost

    
  end
end

main(File.read('google-10000-english-no-swears.txt'))
