class Piece
  FORWARD = [[1, 1], [-1, 1]]
  BACKWARD = [[1, -1], [-1, -1]]

  attr_reader :color

  def initialize(board, pos, color, promoted = false)
    @board, @pos, @color, @promoted = board, pos, color, promoted
  end

  def move(to_pos)
    @board[to_pos] = self
    @board[@pos] = nil
    @pos = to_pos
    @promoted = promote?
    true
  end

  def perform_moves!(move_sequence)
    if move_sequence.length > 1
      move_sequences.each do |move|
        return false unless perform_jump(move)
      end
      return true
    else
      move = move_sequence.first
      performed_slide = perform_slide(move)
      performed_slide unless perform_jump(move)
    end
  end

  def perform_slide(to_pos)
    diff = diff(to_pos, @pos)

    return false unless @board[to_pos].nil? 
    return false unless move_diffs.include?([diff.x, diff.y])

    move(to_pos)
  end

  def perform_jump(to_pos)
    diff = diff(to_pos, @pos)

    jumped_x = (diff.x < 0) ? @pos.x - 1 : @pos.y + 1
    jumped_y = (diff.y < 0) ? @pos.y - 1 : @pos.y + 1
    jumped_pos = [jumped_x, jumped_y]

    jumped = @board[jumped_pos]
    target = @board[to_pos]

    return false unless jump_diffs.include?([x_diff, y_diff])
    return false unless target.nil? && !jumped.nil?
    return false unless jumped.color != @color

    @board[jumped_pos] = nil
    move(to_pos)
  end

  def promote?
    !@promoted && (@pos[1] == 0 || @pos[1] == 7)
  end
  
  def move_diffs
    return FORWARD + BACKWARD if @promoted
    @color == :white ? FORWARD : BACKWARD
  end

  def jump_diffs
    move_diffs.map { |a| a.map { |i| i * 2 } }
  end

  def diff(a, b)
    [a.x - b.x, a.y - b.y]
  end
end
