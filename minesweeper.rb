class ValueError < StandardError
end

class Board

  def self.transform(inp)
    check_input(inp)
    generate_new_grid(inp)
  end

  private

  def self.generate_new_grid(inp)
    inp.each_with_index do |row, row_index|
      row.chars.each_with_index do |char, char_index|
        if char == " "
          num_mines = count_mines(inp, row_index, char_index)
          inp[row_index][char_index] = num_mines.to_s if num_mines > 0  
        end    
      end
    end
    inp
  end

  def self.count_mines(inp, row_index, char_index)
    mine_count = 0
    -1.upto(1) do |row_offset|
      -1.upto(1) do |char_offset|
        next if row_offset ==0 && char_offset == 0
        mine_count +=1 if inp[row_index + row_offset][char_index + char_offset] == "*"
      end
    end
    mine_count
  end

  def self.check_input(inp)
    raise ValueError, "The grid is not a rectangle!" if !is_rectangle?(inp)
    raise ValueError, "Top/bottom walls not properly formed!" if !valid_top_bottom_walls?(inp)
    raise ValueError, "Side walls not properly formed!" if !valid_sidewalls?(inp)
    raise ValueError, "Inner content contains bad characters!" if !valid_row_content?(inp)
  end

  def self.is_rectangle?(inp)
    baseline_size = inp[0].size
    inp.all? { |element| element.size == baseline_size }
  end

  def self.valid_top_bottom_walls?(inp)
    inp[0].match(/^[+]-+[+]$/) && inp[-1].match(/^[+]-+[+]$/)
  end

  def self.valid_sidewalls?(inp)
    1.upto(inp.size - 2) { |row| return false if inp[row][0] != "|" || inp[row][-1] != "|" }
  end

  def self.valid_row_content?(inp)
    1.upto(inp.size - 2) do |row|
      return false if inp[row][1..-2].match(/[^ *]/)
    end
  end

end

inp = ['+-----+', '| * * |', '|     |', '|   * |', '|  * *|',
           '| * * |', '+-----+']

p Board.transform(inp)
