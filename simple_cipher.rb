# assign default key of "d"
# you'll need to validate that key is all lower case alpha
# the cipher default key should maybe be 100 chars in length of "d"

# logic
#   since you are going to need dynamic key reading, you might as well build and use it even for the non dynamic cases
#   use modulus to handle circular need for array

class Cipher
  attr_reader :key
  LOWER_ALPHA = ("a".."z").to_a
  ENCODE = "+"
  DECODE = "-"

  def initialize (key=rand_key)
    raise ArgumentError if !key.match(/\A[a-z]+\z/) || key == ""
    @key = key
  end

  def encode(plaintext)
    transformer(plaintext, ENCODE)
  end

  def decode(encoded_text)
    transformer(encoded_text, DECODE)
  end

  private

  def transformer(text, sign)
    transformed_text = text.split("").map.each_with_index do |char, idx|
      cipher_decipher(char, @key[idx], sign)
    end
    transformed_text.join
  end

  def cipher_decipher(char, char_key, sign)
    shift_amount = char_key.ord - "a".ord
    char_loc = char.ord - "a".ord
    new_loc = (char_loc.send(sign, shift_amount)) % LOWER_ALPHA.size
    cipher_char = LOWER_ALPHA[new_loc]
  end

  def rand_key
    (1..100).to_a.map{|element| LOWER_ALPHA.sample}.join
  end

end

#cipher = Cipher.new
#p cipher.decode("dad")

#cipher.encode("aaaaa")


