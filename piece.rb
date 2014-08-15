class Piece
  FORWARD = [[1, 1], [-1, 1]]
  BACKWARD = [[1, -1], [-1, -1]]

  attr_reader :color, :pos

  def initialize(board, pos, color, promoted = false)
    @board, @pos, @color, @promoted = board, pos, color, promoted
  end

  def move(to_pos)
    @board[to_pos] = self
    @board[@pos] = nil
    @pos = to_pos
    @promoted = true if promote?
    true
  end

  def perform_moves(move_seq)
    raise InvalidMoveError unless valid_move_seq?(move_seq)
    perform_moves!(move_seq)
  end

  def valid_move_seq?(move_seq)
    board_copy = @board.dup
    piece_copy = board_copy[@pos]

    begin
      piece_copy.perform_moves!(move_seq)
      true
    rescue InvalidMoveError
      false
    end
  end

  def perform_moves!(move_seq)
    if move_seq.length > 1
      move_seq.each do |move|
        raise InvalidMoveError unless perform_jump(move)
      end
    else
      move = move_seq.first
      performed_slide = perform_slide(move)
      raise InvalidMoveError unless (performed_slide || perform_jump(move))
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

    jumped_x = (diff.x < 0) ? @pos.x - 1 : @pos.x + 1
    jumped_y = (diff.y < 0) ? @pos.y - 1 : @pos.y + 1
    jumped_pos = [jumped_x, jumped_y]

    jumped = @board[jumped_pos]
    target = @board[to_pos]

    return false unless jump_diffs.include?([diff.x, diff.y])
    return false unless target.nil? && !jumped.nil?
    return false unless jumped.color != @color

    @board[jumped_pos] = nil
    move(to_pos)
  end

  def promote?
    !@promoted && (@pos.y == 0 || @pos.y == 7)
  end
  
  def move_diffs
    return FORWARD + BACKWARD if @promoted
    @color == :red ? FORWARD : BACKWARD
  end

  def jump_diffs
    move_diffs.map { |a| a.map { |i| i * 2 } }
  end

  def diff(a, b)
    [a.x - b.x, a.y - b.y]
  end
end
