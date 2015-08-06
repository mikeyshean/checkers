
require 'colorize'
require 'byebug'

class Piece

  DELTAS = {
    red:   [[-1, 1], [-1, -1]],
    black: [[ 1, 1], [ 1, -1]],
  }

  attr_reader :color, :board
  attr_accessor :pos, :jumped_pos

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
      update_positions(new_pos)
      true
    else
      false
    end
  end

  def perform_jump(new_pos)
    return false if !valid_jump?(new_pos)
    update_positions(new_pos, jumped_pos)
    true
  end


  def valid_jump?(new_pos)
    return false if !board.empty?(new_pos)

    move_diffs.each do |delta|
      dx, dy = delta
      row, col = pos

      @jumped_pos = [row + dx, col + dy]
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

  def perform_moves(move_sequence)
    perform_moves!(move_sequence) if valid_move_sequence?(move_sequence)
  end

  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      perform_slide(move_sequence) || perform_jump(move_sequence)
      return
    end

    return true if move_sequence.all? { |move| perform_jump(move) }

    raise InvalidMoveError.new("Invalid move sequence!")
  end

  def valid_move_sequence?(move_sequence)
    new_board = board.dup
    start_piece = new_board[pos]

    begin
      start_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts e.message
      false
    else
      true
    end
  end

  def update_positions(new_pos, jumped_pos = nil)
    board[self.pos] = nil
    board[new_pos] = self
    self.pos = new_pos

    board[jumped_pos] = nil unless jumped_pos.nil?
    nil
  end

  def king?
    @king
  end

  def move_diffs
    DELTAS[:red] + DELTAS[:black] if king?
    DELTAS[color]
  end

  def jumpable_piece?(jumped_pos, landed_pos)
    !board.empty?(jumped_pos) && board[jumped_pos].color != color
  end

end

class InvalidMoveError < StandardError
end
