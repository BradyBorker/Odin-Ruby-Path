class Rack 
  def initialize()
    @rack = Array.new(6) { Array.new(7, 'O') }
  end

  def place_token(player, column)
    return false if not_in_range?(column)

    row = 5
    until empty_slot?(row, column)
      row -= 1
      return false if row < 0
    end

    @rack[row][column] = player.token
    return true
  end

  def not_in_range?(column)
    return true if column < 0 || column > 6
  end

  def empty_slot?(row, column)
    return true if @rack[row][column] == 'O'
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

# 7 columns
# 6 rows
