class InvalidMoveError < StandardError
  def message
    "Illegal move sequence."
  end
end

class EmptyMoveError < InvalidMoveError
  def message
    "There is no piece to move there."
  end
end

class PermissionError < InvalidMoveError
  def message
    "You cannot move the opposing player's piece."
  end
end
