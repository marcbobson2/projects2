
class Board
  attr_reader :board

  def initialize
    @board = Array.new(8)
    board.map! { |element| "________" }
  end

  def place_piece(piece, piece_char)
    board[piece.row][piece.col] = piece_char
  end

  def generate_board_string
    board.map { |element| element.split("").join(" ")}.join("\n")
  end

  def same_row?(piece1, piece2)
    piece1.row == piece2.row || piece1.col == piece2.col
  end

  def same_diag?(piece1, piece2)
    x_diff = (piece1.row - piece2.row).abs
    y_diff = (piece1.col - piece2.col).abs
    x_diff == y_diff
  end

end

class Pieces
  attr_reader :row, :col

  def initialize(position)
    @row = position[0]
    @col = position[1]
  end

end


class Queens
  WHITE_QUEEN_DEFAULT = [0,3].freeze
  BLACK_QUEEN_DEFAULT = [7,3].freeze
  WHITE_QUEEN_MARKER = "W".freeze
  BLACK_QUEEN_MARKER = "B".freeze

  attr_reader :white, :black

  def initialize(queen_locations={white: WHITE_QUEEN_DEFAULT, black: BLACK_QUEEN_DEFAULT})
      raise ArgumentError, "Two queens cannot occupy same space!" if queen_locations[:white] == queen_locations[:black]
      @white_queen = Pieces.new(queen_locations[:white])
      @black_queen = Pieces.new(queen_locations[:black])
      @board = Board.new
      place_piece_on_board(@white_queen, WHITE_QUEEN_MARKER)
      place_piece_on_board(@black_queen, BLACK_QUEEN_MARKER)
      
  end

  def white
    [@white_queen.row, @white_queen.col]
  end

  def black
    [@black_queen.row, @black_queen.col]
  end

  def to_s
    @board.generate_board_string
  end

  def attack?
    @board.same_row?(@white_queen, @black_queen) || @board.same_diag?(@white_queen, @black_queen)
  end

  private

  def place_piece_on_board(piece, marker)
    @board.place_piece(piece, marker)
  end 

end

queens = Queens.new
puts queens.to_s




