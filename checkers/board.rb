
def Board

  BOARD_SIZE = 8

  def initialize(fillboard = true)
    @grid = populate_grid(fillboard)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

    


end
