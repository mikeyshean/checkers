
require 'colorize'
require 'byebug'

class Piece

  attr_reader :color, :board
  attr_accessor :pos

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
    board.add_piece(self, pos)
  end

  def to_s
    "\u229A".colorize(color)
  end

  def perform_slide(new_pos)
    row, col = pos
    if valid_slide?(new_pos)
      board.move_piece(self, new_pos)
      self.pos = new_pos
      true
    else
      false
    end
  end

  def perform_jump(new_pos)
    row, col = pos

    if valid_jump?(new_pos)
      board.move_piece(self, new_pos)
      self.pos = new_pos
      true
    else
      false
    end
  end


  def valid_jump?(new_pos)
    return false if !board.empty?(new_pos)

    move_diffs.each do |delta|
      dx, dy = delta
      row, col = pos

      jumped_pos = [row + dx, col + dy]
      landed_pos = [row + (2 * dx), col + (2 * dy)]

      return true if jumpable_piece?(jumped_pos, landed_pos)
    end
  end

  def valid_slide?(new_pos)
    return false unless board.empty?(new_pos)

    move_diffs.each do |delta|
     dx, dy  = delta
     row, col = pos

     return true if [row + dx, col + dy] == new_pos
    end
  end

  def king?
    @king
  end

  def move_diffs
    color == :red ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
  end

  def jumpable_piece?(jumped_pos, landed_pos)
    !board.empty?(jumped_pos) && board[jumped_pos].color != color
  end

end
