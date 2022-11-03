require 'colorize'

def display_hangman(wrong_guesses)
  if wrong_guesses == 1
    puts " O"
    puts ""
  elsif wrong_guesses == 2
    puts " O"
    print " |"
    puts ""
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

def display_load_game_menu(game_files)
  puts "Pick a game to load (Enter a number)"
  puts "-" * 20
  game_files.each_pair do |number, game|
    puts "#{number}    #{game}"
  end
  puts "-" * 20
end

def display_guess_history(guess_history)
  guesses = ""
  for character in guess_history.keys
    if guess_history[character] == 'red'
      guesses += "#{character.red} "
    elsif guess_history[character] == 'green'
      guesses += "#{character.green} "
    end
  end
  puts "[ #{guesses}]"
end