# pick best poker hand from a list of hands
# CARDS
# * 2 letters represents hand: 
# first letter = rank 2, 3, 4, 5, 6, 7, 8, 9, T, J, Q, K, and A
# second char = suit S, H, C, D
# 
# HAND EVALUATION
# if only 1 hand submitted, then that is the best hand (no eval even needed)
# hands are passed in as array of arrays

# Algorithm psuedo code
# Take in array of hands
# iterate through array
# for each hand, determine what it is (high card, one pair, two pair etc) --> store in another array
# select the highest result in scores array
# if you have more than one hand of same type (e.g. 2 pair), then you need to go to next level of logic
# Each hand type has its own method of resolution

# Data structure for the hand
# You definitely need to have a notion of ordinal values, so data structure will need to hold integer value
# Suits can continue to be stored as string
# Ace is the trickiest. For straights, it can complete at the low and high end
# In all other situations, ace is always the high card
# So for now, lets build this data structure:
# ["AD", "KH", "2C", "3C", "4S"] --> [[14, "D"], [13, "H"]] etc...

# to pick the best poker hand, you need to start by being able to classify a single hand



class Hand
  attr_reader :cards, :raw_hand, :hand_type

  FACE_CARDS = {"T" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14}

  def initialize(raw_hand)
    @raw_hand = raw_hand
    @cards = convert_to_numeric_hand(raw_hand)
    @hand_type = nil
  end

  def convert_to_numeric_hand(raw_hand)
    raw_hand.map! do |card|
      [split_card_to_value_and_suit(card[0]), card[1]]
    end
  end

  def split_card_to_value_and_suit(card_value_str)
    FACE_CARDS.has_key?(card_value_str) ? FACE_CARDS[card_value_str] : card_value_str.to_i
  end

  def count_multi_cards(num_cards_of_same_value, freq_of_cards_of_same_value)
    card_freq = card_values.uniq.map { |unique_card| card_values.count(unique_card) }
    card_freq.count(num_cards_of_same_value) == freq_of_cards_of_same_value ? true : false
  end

  def one_pair?
    count_multi_cards(2, 1)
  end

  def two_pair?
    count_multi_cards(2, 2)
  end

  def three_of_a_kind?
    count_multi_cards(3, 1)
  end

  def four_of_a_kind?
    count_multi_cards(4, 1)
  end

  def full_house?
    three_of_a_kind? && one_pair?
  end

  def card_values
    @cards.map { |card| card[0] }
  end

  def card_suits
    @cards.map { |card| card[1] }
  end

  def flush?
    card_suits.uniq.size == 1
  end

  def straight?
    return false if card_values.uniq.size != 5
    return true if card_values.max - card_values.min == 4
    has_ace? ? straight_with_low_ace? : false
  end

  def straight_flush?
    straight? && flush?
  end

  def straight_with_low_ace?
    card_values_with_ace_mod = card_values.map { |card_value| card_value == 14 ? 1 : card_value }
    card_values_with_ace_mod.max - card_values_with_ace_mod.min == 4 ? true : false
  end

  def high_card
    card_values.max
  end

  def has_ace?
    card_values.include?(14)
  end

  def hand_type=(hand_score)
    @hand_type = hand_score
  end

  def card_values
    @cards.map { |card| card[0] }.sort
  end

  def sorted_pair_values
    card_values.each_with_object([]) { |card_value, result| result << card_value if card_values.count(card_value) > 1 }.uniq.sort
  end

  def non_paired_cards
    card_values.keep_if { |card_value| card_values.count(card_value) == 1 }
  end

  def full_house_top_card
    card_values.each { |card| return [card] if card_values.count(card) == 3 }
  end

end


class Poker
  attr_reader :hands

  HAND_TYPES = {:straight_flush? => 10, :four_of_a_kind? => 9, :full_house? => 8, :flush? => 7, :straight? =>6, :three_of_a_kind? => 5, 
                :two_pair? => 4, :one_pair? => 3, :high_card => 2 }

  def initialize(hands)
    @hands = hands.map! do |raw_hand|
      Hand.new(raw_hand)
    end
  end

  def best_hand
    assign_highest_hand_type_to_each_hand
    best_hands = get_best_hands 
    return([best_hands[0].raw_hand]) if best_hands.size == 1
      
    case best_hands[0].hand_type
    when :high_card, :straight?, :flush?, :straight_flush? then choose_best_high_card_hand(best_hands, :card_values)
    when :one_pair?, :two_pair?, :three_of_a_kind?, :four_of_a_kind? then choose_best_high_card_hand(best_hands, :sorted_pair_values)
    when :full_house? then choose_best_high_card_hand(best_hands, :full_house_top_card)
    end

    choose_best_high_card_hand(best_hands, :non_paired_cards) if best_hands.size > 1
    best_hands.each_with_object([]) { |hand, result| result << hand.raw_hand }
  end

  def get_best_hands
    highest_hand_type = 0
    @hands.each do |hand|
      highest_hand_type = HAND_TYPES[hand.hand_type] if HAND_TYPES[hand.hand_type] > highest_hand_type
    end
    @hands.select { |hand| HAND_TYPES[hand.hand_type] == highest_hand_type }
  end

  def assign_highest_hand_type_to_each_hand
    score_of_each_hand = []
    @hands.each_with_index do |hand, index| #outer loop for each hand
      HAND_TYPES.each_key do |key|
        if hand.send(key) # found a hand!
          hand.hand_type = key
          break # stop analyzing weaker hand types
        end
      end
    end
  end

  def choose_best_high_card_hand(best_hands, cards_to_analyze)      
    (cards_to_analyze.size - 1).downto(0) do |index|
      high_cards = []
      best_hands.each { |best_hand| high_cards << best_hand.send(cards_to_analyze)[index] }
      max_of_high_cards = high_cards.max
      best_hands.delete_if { |best_hand| best_hand.send(cards_to_analyze)[index] != max_of_high_cards }
      break if best_hands.size == 1
    end
  end
end


game = Poker.new([["JD", "JS", "JH", "TD", "TC"], ["KC", "KS", "TC", "TH", "TC"], ["JS", "JS", "9D", "9H", "AS"]])
#p game.hands[0].one_pair?
p game.best_hand


