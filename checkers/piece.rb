
require 'colorize'

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

  def valid_slide?(new_pos)
    slides = []
    row, col = pos

    move_diffs.each do |delta|
     dx, dy  = delta
     slides << [row + dx, col + dy] if board.empty?(new_pos)
    end

    slides.include?(new_pos)
  end

  def king?
    @king
  end

  def move_diffs
    color == :red ? [[-1, 1], [-1, -1]] : [[1, 1], [1, -1]]
  end



end
