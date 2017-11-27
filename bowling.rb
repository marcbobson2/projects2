class Frame
  attr_reader :score, :frame_num

  MAX_ROLLS_FRAME_1_TO_9 = 2
  MAX_ROLLS_FRAME_10 = 3


  def initialize(frame_num)
    @frame_num = frame_num
    @score = []
  end

  def set_score=(pins_knocked_down)
    @score << pins_knocked_down
  end

  def rolls_remaining
    if frame_num < 10
      strike? || spare? || open_frame? ? 0 : 1
    elsif frame_num == 10 
      if strike?
        MAX_ROLLS_FRAME_10 - score.size 
      elsif score.size == 0
        2
      elsif open_frame? || score.size == 3
        0
      elsif score.size == 1 || spare?
        1
      end
    end
  end

  def total_score
    @score.reduce(&:+)
  end

  def open_frame?
    score.size == 2 && total_score < 10 
  end

  def strike?
    score[0] != nil && score[0] == 10
  end

  def spare?
    return false if score.size < MAX_ROLLS_FRAME_1_TO_9
    (score[0] + score[1]) == 10 && score[0] != 10
  end

  def roll_out_of_range?(pins_knocked_down)
    pins_knocked_down > 10 || pins_knocked_down < 0
  end

  def excess_pins?(pins_knocked_down)
    return false if score.size == 0
    return excess_pins_if_score_size_is_1?(pins_knocked_down) if score.size == 1
    if score.size == 2
      if frame_num < 10
        false
      else
        excess_pins_if_score_size_is_2?(pins_knocked_down)
      end
    end
  end

  def excess_pins_if_score_size_is_1?(pins_knocked_down)
    return false if strike?
    if score.size == 1
      score[0] + pins_knocked_down > 10 ? true : false
    else
      false
    end
  end

  def excess_pins_if_score_size_is_2?(pins_knocked_down)
    if strike? && score[1] == 10
      false
    elsif  strike? && (score[1] + pins_knocked_down > 10)
      true
    elsif strike? || spare?
      false
    elsif open_frame? && score[1] + pins_knocked_down > 10
      true
    else
      false
    end
  end

  def fill_balls_available?
    return false if frame_num < 10 || score.size == 0 || score.size == 3 || open_frame? || (score.size == 1 && !strike?)
    true
  end
end


class Game
  
  NUM_FRAMES = 10
  STRIKE = 10
  FINAL_FRAME_INDEX = 9

  attr_reader :frame_counter, :frames
  
  def initialize
    @frames = Array.new
    1.upto(10) do |n_frame|
      @frames << Frame.new(n_frame)
    end
  end

  def roll(pins_knocked_down)
    active_frame_index = get_next_available_frame
    check_for_runtime_errors(active_frame_index, pins_knocked_down)
    frames[active_frame_index].set_score=(pins_knocked_down)
  end

  def check_for_runtime_errors(active_frame_index, pins_knocked_down)
    raise RuntimeError, 'Should not be able to roll after game is over' if active_frame_index == false
    raise RuntimeError, 'Pins must have a value from 0 to 10' if frames[active_frame_index].roll_out_of_range?(pins_knocked_down)
    raise RuntimeError, 'Pin count exceeds pins on the lane' if frames[active_frame_index].excess_pins?(pins_knocked_down)
  end

  def score
    raise RuntimeError, game_done_message if get_next_available_frame
    score_of_all_frames = 0
    @frames.each_with_index { |frame, index| score_of_all_frames += single_frame_score(frame, index) }
    score_of_all_frames
  end

  def game_done_message
    active_frame_index = get_next_available_frame
    frames[active_frame_index].fill_balls_available? ? "Game is not yet over, cannot score!" : "Should not be able to roll after game is over"
  end

  def single_frame_score(frame, index)
    frame_score = 0
    return frame.total_score if index == 9
    if frame.strike?
      frame_score += frame.score[0] + next_n_rolls(index, 2)
    elsif frame.spare?
      frame_score += frame.total_score + next_n_rolls(index, 1)
    else
      frame_score += frame.total_score
    end
    frame_score
  end

  def next_n_rolls(index, scores_to_grab)
    cumulative_score = 0
    scores_found = 0
    (index + 1).upto(@frames.size - 1) do |frame_index|
      scores_to_grab.times do |x|
        if @frames[frame_index].score[x].class == Integer
         cumulative_score += @frames[frame_index].score[x]
         scores_found += 1
        end
        return cumulative_score if scores_found == scores_to_grab
      end
    end
  end

  def get_next_available_frame
    frames.each_with_index do |frame, index|
      return index if frame.rolls_remaining > 0
    end
    false
  end
end

#game = Game.new
#game.roll_n_times(18, 0)
#game.roll(10)
#game.roll(5)
#game.roll(6)





#p game.frames[9].rolls_remaining






