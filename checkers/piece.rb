
class Piece

  attr_reader :color, :board

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
    board.add_piece(self, pos)
  end

  def to_s
    color.to_s
  end

  def king?
    @king
  end

  def move_diffs
    color == :red ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
  end



end
