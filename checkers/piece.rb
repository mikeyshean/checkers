
class Piece

  attr_reader :color

  def initialize(color, pos)
    @color = color
    @pos = pos
  end

  def to_s
    color.to_s
  end


end
