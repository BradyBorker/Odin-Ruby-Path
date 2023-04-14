def save_game(board)
  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
  saved_game = Marshal.dump(board)
  filename = "saved_games/#{board.players[0].name}-#{board.players[1].name}-#{Time.now().strftime("%b-%w-%-I:%M%p")}"

  File.open(filename, 'w') { |file| file.puts saved_game }
  puts 'Game Saved!'
end

def load_game()
  counter = 1
  game_files = {}
  Dir.each_child("saved_games") do |file|
    game_files[counter] = file
    counter += 1
  end

  game_files.each do |number, file|
    puts "#{number}   #{file}"
  end

  choice = gets.chomp.to_i
  until game_files.keys.include?(choice)
    puts 'File does not exist'
    choice = gets.chomp.to_i
  end

  File.open("saved_games/#{game_files[choice]}") { |file| Marshal.load(file.read) }
end