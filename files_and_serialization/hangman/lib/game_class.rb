class Game
  attr_accessor :hidden_word
  attr_reader :wrong_guesses, :guess_history

  def initialize(word)
    @chosen_word = word
    @hidden_word = '_' * word.length
    @current_guess = ''
    @wrong_guesses = 0
    @guess_history = {}
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
      self.guess_history[@current_guess] = 'red'
    elsif
      self.guess_history[@current_guess] = 'green'
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