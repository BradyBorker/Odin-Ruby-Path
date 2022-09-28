#Tic-Tac-Toe

class Board
  attr_accessor :board
  def initialize()
    @board = ['1','2','3','4','5','6','7','8','9']
    @@spaces_left = 9
  end

  def self.remove_space()
    @@spaces_left -= 1
  end

  def self.spaces_left()
    @@spaces_left
  end
end

class Person
  def initialize(name)
    @name = name
  end
end

class Player < Person
  attr_reader :name, :sign
  def initialize(name, sign)
    super(name)
    @sign = sign
  end
end

board = Board.new
player1 = Player
player2 = Player

def create_player1(player1)
  puts "Player 1 name: "
  name = gets.chomp()
  puts "Player 1 sign: "
  sign = gets.chomp()
  player1.new(name, sign)
end

def create_player2(player2)
  puts "Player 2 name: "
  name = gets.chomp()
  puts "Player 2 sign: "
  sign = gets.chomp()
  player2.new(name, sign)
end

def make_move(board, player)
  puts "Choose a location between 1 and 9"
  location = gets.chomp().to_i - 1
  board.board[location] = player.sign
  Board.remove_space
end

def check_win(board, player, win_states)
  counter = 0
  for win_state in win_states
    for location in win_state
      if board.board[location] == player.sign
        counter += 1
      end
    end
    if counter >= 3
      #Player WON
      puts "#{player.name} Won!"
      #End game logic
      return true
    else 
      counter = 0
    end
  end
end

def print_board(board)
  print board.board[0] + '|' + board.board[1] + '|' + board.board[2]
  puts ''
  print '-----'
  puts ''
  print board.board[3] + '|' + board.board[4] + '|' + board.board[5]
  puts ''
  print '-----'
  puts ''
  print board.board[6] + '|' + board.board[7] + '|' + board.board[8]
  puts ''
end

def play_turn(player, board, win_states)
  puts "#{player.name}'s turn!"
  # Make move!
  make_move(board, player)
  #Print board
  print_board(board)
  # Check Win!
  if (check_win(board, player, win_states)) == true
    return true
  end
end

def play_game(board, player1, player2)
  win_states = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[6,4,2]]
  player1 = create_player1(player1)
  player2 = create_player2(player2)
  turn = 1
  while true
    if turn == 1
      turn = 2
      if (play_turn(player1, board, win_states))
        break
      end
    elsif turn == 2
      turn = 1
      if (play_turn(player2, board, win_states))
        break
      end
    end
    if Board.spaces_left == 0
      puts "It's a TIE!"
      break
    end
  end
end

play_game(board, player1, player2)

