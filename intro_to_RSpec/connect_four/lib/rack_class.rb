class Rack
  def initialize()
    @rack = Array.new(6) { Array.new(7, 'O') }
    @last_token = nil
  end

  def place_token(player, column)
    return false if not_in_range?(column)

    row = 5
    until empty_slot?(row, column)
      row -= 1
      return false if row < 0
    end

    @last_token = [row, column]
    @rack[row][column] = player.token
    true
  end

  def not_in_range?(column)
    column < 0 || column > 6
  end

  def empty_slot?(row, column)
    @rack[row][column] == 'O'
  end

  def game_over?
    [check_horizontal, check_vertical, check_negative_diag, check_positive_diag].any?
  end

  def check_horizontal
    row = @last_token[0]
    column = @last_token[1] + 1
    token = @rack[row][column]

    counter = 1
    while @rack[row][column] == token 
      counter += 1
      column += 1
    end
    
    column = @last_token[1] - 1
    while @rack[row][column] == token
      counter += 1
      column -= 1
    end

    return true if counter >= 4
  end

  def check_vertical

  end

  def check_positive_diag

  end

  def check_negative_diag

  end

  def print_board
    puts ''
    @rack.each do |row|
      row.each do |column|
        print(column + ' ')
      end
      puts ''
    end
    print('1 2 3 4 5 6 7')
    puts ''
  end
end