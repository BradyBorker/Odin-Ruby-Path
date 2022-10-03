# Mastermind
module Feedback
  def find_red_pins(code_copy, feedback, guess)
    for index in 0...code_copy.length
      if code_copy[index] == guess[index]
        feedback[:Red] += 1
        code_copy[index] = '*'
      end
    end
    return feedback
  end

  def find_white_pins(code_copy, feedback, guess)
    for guess_index in 0...guess.length
      for code_index in 0...code_copy.length
        if guess[guess_index] == code_copy[code_index]
          feedback[:White] += 1
          code_copy[code_index] = '*'
        end
      end
    end
    return feedback
  end

  def give_feedback(code, guess)
    code_copy = []
    code.each {|color| code_copy.push(color)}
    feedback = {Red: 0, White: 0}
    find_red_pins(code_copy, feedback, guess)
    find_white_pins(code_copy, feedback, guess)    
    return feedback
  end
end

class CodeMaker
  include Feedback
  def initialize(colors)
    @code = colors
  end

  def give_feedback(guess)
    super(self.code, guess)
  end

  protected
  attr_reader :code
end

class CodeBreaker
  attr_accessor :current_guess, :guess_history

  def initialize()
    @guess_history = []
    @current_guess = []
  end

  def make_guess(guess)
    self.current_guess = guess
    self.guess_history.push(guess)
  end
end

def computer_create_code(color_pool)
  colors = []
  4.times {colors.push(color_pool.sample)}
  # MANUALLY CREATING CODE REVERT AFTER TESTING
  return CodeMaker.new(['red','green','blue','yellow'])
end

def human_make_guess(color_pool)
  puts "Select 4 Colors from Color List"
  print '-----'
  puts ''
  print "Color list:"
  puts ''
  print "#{color_pool}"
  puts ''
  print '-----'
  puts ''
  guesses = []
  while true
    if guesses.length == 4
      return guesses
    end
    guess = gets.chomp()
    if color_pool.include?(guess)
      guesses.push(guess)
    else
      puts "Color is not in color pool"
      puts "Please try again"
    end
  end
end

def play_game()
  color_pool = ['red','green','blue','yellow','orange','purple']
  # If COMPUTER is code maker
  # CODE CREATION
  # MANUALLY CREATING CODE REVERT AFTER TESTING
  code_maker = computer_create_code(color_pool)
  # Make human Code Breaker
  code_breaker = CodeBreaker.new()
  # Start loop 12 rounds max (base on guess_history size? or for loop.)
  # HUMAN GUESSER
  while true 
    code_breaker.make_guess(human_make_guess(color_pool))
    # Compare guess with code/ Give feedback/ Check Win (4 reds == win)
    feedback = code_maker.give_feedback(code_breaker.current_guess)
    p feedback


    
    if code_breaker.guess_history.length == 3
      return
    end
  end
end

play_game()