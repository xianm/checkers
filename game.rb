require_relative 'board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
  end
end

if __FILE__ == $PROGRAM_NAME

end
