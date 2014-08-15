class InvalidMoveError < StandardError
  def message
    "Illegal move sequence"
  end
end

class EmptyMoveError < InvalidMoveError
  def message
    "You cannot move an empty piece."
  end
end

class PermissionError < InvalidMoveError
  def message
    "You cannot move the opposing player's piece."
  end
end
