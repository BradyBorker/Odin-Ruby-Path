# Mastermind

class CodeMaker
  attr_reader :code
  def initialize(colors)
    @code = colors
  end
end

class CodeBreaker
  def initialize()
    @guess_history = []
  end

  def make_guess()
    
  end
end

# Code Maker (Computer) randomly selects 6 colors: red, green, blue, yellow, orange, purple 
# Can be any color, any order, or any amount
def computer_create_code(color_pool)
  colors = []
  4.times {colors.push(color_pool.sample)}
  return CodeMaker.new(colors)
end

def play_game()
  color_pool = ['red','green','blue','yellow','orange','purple']
  # If COMPUTER is code maker
  code_maker = computer_create_code(color_pool)
  p code_maker
end

play_game()