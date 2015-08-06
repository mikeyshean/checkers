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

  def empty?(pos)
    self[pos].nil?
  end


  def render
    grid.each do |row|
      row = row.map { |el| el.nil? ? " " : el }
      puts row.join(" ")
    end
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
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.render
end
