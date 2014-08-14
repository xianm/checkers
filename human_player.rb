class HumanPlayer
  attr_reader :name, :color

  def initialize(name, color)
    @name, @color = name, color
  end

  def get_move_seq
    pattern = /\b([a-h]{1})(\d+)/i
    begin
      print "#{@name} > "
      input = gets.chomp

      raise InvalidInputError unless input.split.all? { |s| s.match(pattern) }

      moves = input.scan(pattern)
      moves.map { |move| parse_move(move) }
    rescue InvalidInputError => error
      puts error.message
      retry
    end
  end

  private
  def parse_move(move)
    [move.x.ord - 'a'.ord, move.y.to_i - 1]
  end
end

class InvalidInputError < StandardError
  def message
    "Invalid input, try again."
  end
end
