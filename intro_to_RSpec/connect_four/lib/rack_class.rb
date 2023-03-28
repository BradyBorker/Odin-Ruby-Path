require 'colorize'

class Rack 
  attr_reader :rack
  def initialize()
    @rack = Array.new(6) { Array.new(7, 'O'.colorize(:grey)) }
  end
end

# 7 columns
# 6 rows
