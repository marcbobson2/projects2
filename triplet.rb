class Triplet
  def self.where(options)
    possible_triplets = TripletsEnumerator.new(options)

    possible_triplets
      .select(&:pythagorean?)
      .reject(&:invalid_sum?)
  end

  def initialize(a, b, c, required_sum = nil)
    @a, @b, @c = a, b, c
    @required_sum = required_sum
  end

  def sum
    @a + @b + @c
  end

  def product
    @a * @b * @c
  end

  def pythagorean?
    @a**2 + @b**2 == @c**2
  end

  def invalid_sum?
    @required_sum && sum != @required_sum
  end
end

class TripletsEnumerator
  include Enumerable

  def initialize(config)
    @max = config[:max_factor] || fail(ArgumentError, 'max_factor required')
    @min = config[:min_factor] || 1
    @sum = config[:sum]
  end

  def each
    @min.upto(@max - 1) do |a|
      a.upto(@max - 1) do |b|
        b.upto(@max) do |c|
          yield Triplet.new(a, b, c, @sum)
        end
      end
    end
  end
end
