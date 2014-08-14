require 'colorize'
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
    buffer = "  | "
    buffer += (0...8).to_a.join(" ")
    buffer += "\n--+-----------------\n"

    @field.each_with_index do |row, y|
      buffer += "#{y} | "
      row.each_with_index do |cell, x|
        str = ""

        if cell.nil?
          str = "  "
        else
          str = cell.color == :red ? "◉ ".red : "◉ ".light_white
        end
        
        if (x % 2 != y % 2)
          str = str.on_green
        else
          str = str.on_light_yellow
        end
        
        buffer += str
      end
      buffer += "\n"
    end

    buffer
  end

  def reset_field
    3.times do |y|
      x = y.even? ? 1 : 0
      4.times do
        self[[x, y]] = Piece.new(self, [x, y], :white)
        self[[x - 1, 7 - y]] = Piece.new(self, [x - 1, 7 - y], :red)
        x += 2
      end
    end
  end
end
