require_relative 'patches'
require_relative 'piece'

class Board
  attr_reader :field

  def initialize(reset = true)
    @field = Array.new(8) { Array.new(8) }
    reset_field if reset
  end

  def [](pos)
    x, y = pos
    @field[y][x]
  end

  def []=(pos, value)
    x, y = pos
    @field[y][x] = value
  end

  def to_s
    buffer = ""

    @field.each do |row|
      row.each do |cell|
        buffer += cell.nil? ? "_" : "o"
        buffer += " "
      end
      buffer += "\n"
    end

    buffer
  end

  def reset_field
    3.times do |y|
      x = y.even? ? 1 : 0
      4.times do
        self[[x, y]] = Piece.new(self, [x, y], :red)
        self[[x - 1, 7 - y]] = Piece.new(self, [x - 1, 7 - y], :white)
        x += 2
      end
    end
  end
end
