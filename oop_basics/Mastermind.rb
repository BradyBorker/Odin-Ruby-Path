# Mastermind
module Feedback
  def find_red_pins(code_copy, feedback, guess)
    for index in 0...4
      if code_copy[index] == guess[index]
        feedback[:Red] += 1
        code_copy[index] = '*'
      end
    end
    return feedback
  end

  def find_white_pins(code_copy, feedback, guess)
    for guess_index in 0...4
      for code_index in 0...4
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

  def trim_all_possible_combinations(all_possible_combinations, current_guess, current_feedback)
    #copy_all_possible_combinations = []
    #all_possible_combinations.each {|combination| copy_all_possible_combinations.push(combination)}
    trimmed_possible_combinations = []
    for code_combination in all_possible_combinations
      if code_combination == current_guess
        next
      end
      potential_answer = []
      feedback = {Red: 0, White: 0}
      code_combination.each {|color| potential_answer.push(color)}
      find_red_pins(code_combination, feedback, current_guess)
      find_white_pins(code_combination, feedback, current_guess)
      if feedback == current_feedback
        trimmed_possible_combinations.push(potential_answer)
      end
    end
    return trimmed_possible_combinations
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

  def trim_all_possible_combinations(all_possible_combinations, current_guess, current_feedback)
    super(all_possible_combinations, current_guess, current_feedback)
  end
  protected
  attr_reader :code
end

class CodeBreaker
  attr_accessor :current_guess, :guess_history, :turn_number

  def initialize()
    @guess_history = []
    @current_guess = []
    @turn_number = 1
  end

  def make_guess(guess)
    self.current_guess = guess
    self.guess_history.push(guess)
    self.turn_number += 1
  end
end

def game_intro()
  puts "Hello! Welcome to my Mastermind game!"
  puts "Would you like to be the Code Maker? Or Breaker?"
  while true
    answer = gets.chomp().downcase
    if answer == 'maker'
      return 'maker'
    elsif answer == 'breaker'
      return 'breaker'
    else
      puts "Please enter either 'creator' or 'breaker'"
    end
  end
end

def display_color_pool(color_pool)
  puts "Select 4 Colors from Color List"
  print '-----'
  puts ''
  print "Color list:"
  puts ''
  print "#{color_pool}"
  puts ''
  print '-----'
  puts ''
end

def computer_create_code(color_pool)
  colors = []
  4.times {colors.push(color_pool.sample)}
  return CodeMaker.new(colors)
end

def computer_make_guess(all_possible_combinations, current_guess, feedback, code_maker)
  # Compare current guess with all possible combinations
  # Treat each individual code in all_possible_combinations as potential code
  # Treat current_guess as guess against those codes
  # If feedback matches, that individual code is a potential answer, if doesn't match disregard
  #all_possible_combinations = code_maker.trim_all_possible_combinations(all_possible_combinations, current_guess, feedback)
end

def human_create_code(color_pool)
  display_color_pool(color_pool)
  colors = []
  while true
    if colors.length == 4
      return CodeMaker.new(colors)
    end
    color = gets.chomp().downcase
    if color_pool.include?(color)
      colors.push(color)
    else
      puts "Color is not in color pool"
      puts "Please try again"
    end
  end
end

def human_make_guess(color_pool)
  display_color_pool(color_pool)
  guesses = []
  while true
    if guesses.length == 4
      return guesses
    end
    guess = gets.chomp().downcase
    if color_pool.include?(guess)
      guesses.push(guess)
    else
      puts "Color is not in color pool"
      puts "Please try again"
    end
  end
end

def output_feedback(feedback)
  puts "-------"
  puts "FEEDBACK"
  puts "Red Pins: #{feedback[:Red]}"
  puts "White Pins: #{feedback[:White]}"
  puts "-------"
end

def play_game()
  color_pool = ['red','green','blue','yellow','orange','purple']
  player_selection = game_intro()
  # Human is breaker
  # Computer is maker
  if player_selection == 'breaker'
    code_maker = computer_create_code(color_pool)
    code_breaker = CodeBreaker.new()
    while true 
      code_breaker.make_guess(human_make_guess(color_pool))
      # Compare guess with code/ Give feedback/ Check Win (4 reds == win)
      feedback = code_maker.give_feedback(code_breaker.current_guess)
      output_feedback(feedback)
      # Win Condition
      if feedback[:Red] == 4
        puts "YOU WIN!"
        return
      elsif code_breaker.guess_history.length == 12
        puts "YOU LOSE!"
        return
      end
    end
  # Human is maker
  # Computer is breaker
  elsif player_selection == 'maker'
    all_possible_combinations = color_pool.repeated_permutation(4)
    trimmed_possible_combinations = []
    code_maker = human_create_code(color_pool)
    code_breaker = CodeBreaker.new()
    while true
      if code_breaker.turn_number == 1
        code_breaker.make_guess(['red','red','green','green'])
        feedback = code_maker.give_feedback(code_breaker.current_guess)
      else
        # Trim combinations using previous feedback
        # Make guess using new list created
        # Get feedback
        all_possible_combinations = code_maker.trim_all_possible_combinations(all_possible_combinations, code_breaker.current_guess, feedback)
        p all_possible_combinations.length
        p feedback
        puts "COMPUTER GUESS: "
        p all_possible_combinations[0]
        code_breaker.make_guess(all_possible_combinations[0])

        #code_breaker.make_guess(computer_make_guess(all_possible_combinations, code_breaker.current_guess, feedback, code_maker))
        feedback = code_maker.give_feedback(code_breaker.current_guess)
      end
      
      #puts "COMPUTER GUESS!"
      #p code_breaker.current_guess
      if feedback[:Red] == 4
        puts "YOU WIN!"
        return
      elsif code_breaker.guess_history.length == 12
        puts "YOU LOSE!"
        return
      end
    end
  end
end

play_game()