
require 'colorize'
require 'byebug'

class Piece

  DELTAS = {
    red:   [[-1, 1], [-1, -1]],
    black: [[ 1, 1], [ 1, -1]],
  }

  attr_reader :color, :board
  attr_accessor :pos, :king, :jumped_piece_pos

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
    @king = false
    board.add_piece(self, pos)
  end

  def to_s
    (king? ? "\u2622" : "\u229A").colorize(color)
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
    update_positions(new_pos, jumped_piece_pos)
    true
  end

  def perform_moves(move_sequence)
    perform_moves!(move_sequence) if valid_move_sequence?(move_sequence)
    maybe_promote
  end

  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      perform_slide(move_sequence.first) || perform_jump(move_sequence.first)
      return
    end

    prev_piece = self
    move_sequence.each do |move|

      if prev_piece.perform_jump(move)
        prev_piece = board[move]
      else
        raise InvalidMoveError.new("Invalid move sequence!")
      end
    end

    self
  end

  # private

  def valid_jump?(new_pos)
    return false if !board.empty?(new_pos)

    move_diffs.each do |delta|
      dx, dy = delta
      row, col = pos

      self.jumped_piece_pos = [row + dx, col + dy]
      landed_pos = [row + (2 * dx), col + (2 * dy)]

      return true if jumpable_piece?(jumped_piece_pos, landed_pos) &&
        landed_pos == new_pos
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

  def update_positions(new_pos, jumped_piece_pos = nil)
    board[self.pos] = nil
    board[new_pos] = self
    self.pos = new_pos

    board[jumped_piece_pos] = nil unless jumped_piece_pos.nil?
    nil
  end

  def king?
    @king
  end

  def maybe_promote
    self.king = true if (color == :red ? pos[0] == 0 : pos[0] == 7)
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
