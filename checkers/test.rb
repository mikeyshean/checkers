
load 'board.rb'
b = Board.new(false)
Piece.new(:red, b, [7,2])
Piece.new(:black, b, [6,3])
Piece.new(:black, b, [4,3])

b[[7,2]].perform_moves([[5,3],[3,2]])
