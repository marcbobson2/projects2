# Data structure: array of n strings, where n=number of rails
# Encode:
# take each char in input string, left to right
# string1<<char 1
# string2<<char 2
# string3<<char 3
# string2<<char 4
# string1<<char 5
# so this is a pyramiding algorithm
# once all encrypted strings are formed, just join them and return
#
# Decode:
# Just reverse the encoding process

require 'pry'

class RailFenceCipher

  def self.encode(user_input, n_rails)
    return user_input if user_input.empty? || n_rails == 1
    encoded_results = Array.new(n_rails) {""}
    user_input_arr = user_input.chars

    while !user_input_arr.empty? do
      build_rails(encoded_results, user_input_arr, 0, n_rails - 2, :upto)
      build_rails(encoded_results, user_input_arr, n_rails - 1, 1, :downto)
    end
    encoded_results.join
  end

  def self.decode(user_input, n_rails)
    return user_input if user_input.empty? || n_rails == 1
    decoded_results = Array.new(n_rails) {""}
    user_input_arr = user_input.chars
     while !user_input_arr.empty? do
      build_rails(decoded_results, user_input_arr, 0, n_rails - 2, :upto)
      build_rails(decoded_results, user_input_arr, n_rails - 1, 1, :downto)
    end
    decoded_results.map! { |element| user_input.slice!(0..element.size - 1)}
    decode_rails(decoded_results)
  end


  private

  def self.build_rails(encoded_results, user_input_arr, first_val, second_val, direction)
    first_val.send(direction, second_val) do |index|
      break if user_input_arr.empty?
      encoded_results[index] << user_input_arr.shift
    end
  end

  def self.decode_rails(decoded_results)
    decoded_string = ""
    while decoded_results.any? { |element| element.size > 0 } do   
      decoded_string << decode_rail_portion(decoded_results)
      decoded_string << decode_rail_portion(decoded_results.reverse)
    end
    decoded_string
  end

  def self.decode_rail_portion(decoded_results)
    result = ""
    decoded_results.each_with_index do |element, index|
      next if element.size == 0
      break if index == decoded_results.index(decoded_results.last)
      result << element.slice!(0)
    end
    result
  end

end


 p RailFenceCipher.decode('abcde', 3)
 #p RailFenceCipher.work_the_rail_decode(["hello", "goodbye"])



