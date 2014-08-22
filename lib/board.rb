require 'colorize'
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

  def pieces
    @field.flatten.compact
  end

  def pieces_by_color(color)
    pieces.select { |piece| piece.color == color }
  end

  def player_is_blocked?(color)
    pieces_by_color(color).all? { |piece| piece.blocked? }
  end

  def dup
    board_copy = Board.new(false)
    pieces.each do |piece|
      board_copy[piece.pos] = Piece.new(board_copy, piece.pos, piece.color, piece.promoted)
    end
    board_copy
  end

  def to_s
    buffer = "  | "
    buffer += ('a'..'h').to_a.join(" ")
    buffer += "\n--+-----------------\n"

    @field.each_with_index do |row, y|
      buffer += "#{y + 1} | "
      row.each_with_index do |cell, x|
        str = ""

        if cell.nil?
          str = "  "
        else
          if cell.color == :red
            str = "#{cell} ".red
          else
            str = "#{cell} ".white
          end
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
        self[[x, y]] = Piece.new(self, [x, y], :red)
        self[[x - 1, 7 - y]] = Piece.new(self, [x - 1, 7 - y], :white)
        x += 2
      end
    end
  end

  def try_move_seq(mover_color, move_seq)
    raise InvalidMoveError if move_seq.count < 2

    piece = self[move_seq.first]

    raise EmptyMoveError if piece.nil?
    raise PermissionError if piece.color != mover_color

    piece.perform_moves(move_seq[1..-1])
  end
end
