# Requirements
# => Definition: saddle point is a number in a matrix >= to any other number in its row, and <= every element in its column
# => Matrix may have 0 or more saddlepoints
# => Matrix can be of any size

# => Input
# => Matrix inputted as a string with newlines to separate rows

# => Output
# => Need to be able to return an array of a specific row or column
# => Need to be able to return an array of zero or more saddle points, in the form of [[row,col], [row, col]...]

# => Algorithm to find saddle points
# => Loop through each element of the matrix
# => Somehow capture each row and column related to that element
# => Test the element against the row and column.  Use a.max type log
# => if tests true, then store the row, col coordinates in a results array

# => Data model
# => Matrix should be an array of arrays

# => Object model
# => Unsure. Let's code into single class and see if it needs to be refactored.


class Matrix
  attr_reader :data

  def initialize(matrix_str)
    @data = convert_to_matrix(matrix_str)
  end

  def rows
    @data
  end

  def columns
    @data.transpose
  end

  def saddle_points
    result = []
    rows.each_with_index do |row, row_index|
      row.each_with_index do |element, column_index|
          result << [row_index, column_index] if is_saddle_point?(row_index, column_index)
      end
    end
    result
  end


  private

  def is_saddle_point?(row_index, column_index)
    rows[row_index][column_index] == rows[row_index].max && rows[row_index][column_index] == columns[column_index].min
  end

  def convert_to_matrix(matrix_str)
    matrix_str.split("\n").map do |element|
      element.split(" ").map(&:to_i)
    end
  end
end

matrix = Matrix.new("18 3 39 19 91\n38 10 8 77 320\n3 4 8 6 7")
p matrix.rows[0][1]




