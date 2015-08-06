
require_relative 'board'

class Game

ORD_DELTA = 97

  def initialize
    @board = Board.new
  end

  def play
    until over?
      board.render
      play_turn
    end
  end

  def play_turn
    begin
      start_piece, move_sequence = get_move
    end

  end


  def get_move
    print "Enter a move sequence: "
    sequence = convert(gets.chomp)
    [sequence.first, [sequence.drop(1)]]
  end

  def convert(sequence)
    converted_sequence = []
    sequence = sequence.split(",").map { |pair| pair.split("") }

    sequence.map do |pos|
      col, row = pos

      col = col.ord - ORD_DELTA
      row = Board::BOARD_SIZE - Integer(row)
      converted_sequence << [row, col]
    end

    converted_sequence
  end
end
