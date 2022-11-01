class Game
  attr_accessor :display_guesses, :hidden_word

  def initialize(word)
    @chosen_word = word
    @hidden_word = '_' * word.length
    @current_guess = ''
  end

  def self.pick_word(word_list)
    word_list = word_list.split().select {|word| word.length >= 5 && word.length <= 12}
    self.new(word_list.sample)
  end

  def check_char_against_word(character)
    @current_guess = character
    @guess_history.push(@current_guess)
    @indexes = []
    self.chosen_word.split('').each_with_index {|value, index| @indexes.push(index) if value == @current_guess}
  end

  def update_hidden_word()
    @indexes.each do |index|
      self.hidden_word[index] = @current_guess
    end
    puts self.hidden_word
  end

  protected
  
  attr_reader :chosen_word
end

def make_guess()
  puts "Make a guess... Can only pick one character!"
  while true
    guess = gets.chomp
    if guess.match?(/[[:alpha:]]/) && guess.length == 1
      return guess
    else
      puts "Incorrect Input!"
    end
  end
end

def main(word_list)
  # If new game
  game_instance = Game.pick_word(word_list)

  # TODO: Create game from load file

  temp_turn = 0
  while true
    if temp_turn == 3
      return
    end

    guess = make_guess()
    game_instance.check_char_against_word(guess)
    game_instance.update_hidden_word()
    #TODO: Check if game won or lost
    
    temp_turn += 1
  end
end

main(File.read('google-10000-english-no-swears.txt'))
