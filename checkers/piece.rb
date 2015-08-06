
class Piece

  attr_reader :color, :board

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    board.add_piece(self, pos)
  end

  def to_s
    color.to_s
  end


end
