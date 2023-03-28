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
  end

  def not_in_range?(column)
    return true if column < 0 || column > 6
  end

  def empty_slot?(row, column)
    return true if @rack[row][column] == 'O'
  end

  def game_over?
    return false
  end

  def check_horizontal

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