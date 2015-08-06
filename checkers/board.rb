require_relative 'piece'

class Board

  BOARD_SIZE = 8

  attr_reader :grid

  def initialize(fillboard = true)
    populate_grid(fillboard)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def move_piece(piece, new_pos)
    self[piece.pos] = nil
    self[new_pos] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

  def dup
    new_board = Board.new(false)
    pieces.each do |piece|
      Piece.new(piece.color, new_board, piece.pos)
    end
    new_board
  end

  def pieces
    grid.flatten.compact
  end

  def render
    color = [:default, :white]
    grid.each do |row|
      row = row.map { |el| el.nil? ? " " : el }
      row.each do |square|
        print " #{square} ".colorize(:background => color.first)
        color.rotate!
      end
      color.rotate!
      print "\n"
    end
    self
  end

  def populate_grid(fillboard)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    return unless fillboard

    [:red, :black].each do |color|
      (0..2).each do |row_delta|
        row = (color == :red ? 5 : 0)
        row += row_delta

        BOARD_SIZE.times do |col|
          case (row % 2)
          when 0
            Piece.new(color, self, [row, col]) if col % 2 == 1
          when 1
            Piece.new(color, self, [row, col]) if col % 2 == 0
          end
        end
      end
    end
    self
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
  p b[[2,1]].perform_slide([3,2])
  b.render
  p b[[3,2]].perform_slide([4,3])
  b.render
  p b[[5,2]].perform_jump([3,4])
  b.render
end
