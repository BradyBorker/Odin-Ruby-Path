require_relative "display.rb"
require_relative "game_class.rb"

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

  display_load_game_menu(game_files)

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
  game_instance = start_game(word_list)

  display_menu()

  display_game(game_instance)
  
  while true
    input = player_input(game_instance)
    return if input.nil?

    game_instance.check_guess_against_word(input)
    game_instance.update_hidden_word()

    display_game(game_instance)

    return if game_instance.check_win() || game_instance.check_lose()
  end
end

main(File.read('google-10000-english-no-swears.txt'))
