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

def display_load_game_menu(game_files)
  puts "Pick a game to load (Enter a number)"
  puts "-" * 20
  game_files.each_pair do |number, game|
    puts "#{number}    #{game}"
  end
  puts "-" * 20
end