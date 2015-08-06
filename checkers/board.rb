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

  def populate_grid(fillboard)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    return unless fillboard

    [:red, :black].each do |color|
      [0,1,2].each do |row_delta|
        row = (color == :red ? 5 : 0)
        row += row_delta
        (0...BOARD_SIZE).each do |col|
          case (row % 2)
          when 0
            self[[row, col]] = Piece.new(color, [row, col]) if col % 2 == 1
          when 1
            self[[row, col]] = Piece.new(color, [row, col]) if col % 2 == 0
          end
        end
      end
    end
  end

end
