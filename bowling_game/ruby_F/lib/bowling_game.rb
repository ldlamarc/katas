class BowlingGame
  MAX_PINS = 10
  MAX_ROLLS_IN_FRAME = 2
  STRIKE_LOOKAHEAD = 2
  SPARE_LOOKAHEAD = 1
  BONUS_LOOKAHEADS = [STRIKE_LOOKAHEAD, SPARE_LOOKAHEAD]
  MAX_FRAMES = 10

  def self.roll *rolls
    new(rolls)
  end

  def score
    map_frame_score { |frame, score| score }.reduce(0, :+)
  end

  def to_s
    map_frame_score { |frame, score| frame.to_s(score) }.join('::')
  end

  private

  attr_reader :rolls

  def initialize(rolls)
    @rolls = rolls
  end

  def map_frame_score(&block)
    padded_frames.each_cons(1 + BONUS_LOOKAHEADS.max).map do |frame, *lookahead_frames|
      yield(frame, frame.score(lookahead_frames))
    end
  end

  def padded_frames
    min_length_for_score = MAX_FRAMES + BONUS_LOOKAHEADS.max
    (frames + Array.new(min_length_for_score){ Frame.from_rolls([]) }).first(min_length_for_score)
  end

  def frames
    split_rolls_in_frames.map { |rolls| Frame.from_rolls(rolls) }
  end

  # A frame ends after MAX_PINS or MAX_ROLLS_IN_FRAME
  def split_rolls_in_frames
    rolls.slice_after(MAX_PINS).map { |el| el.each_slice(MAX_ROLLS_IN_FRAME).to_a }.flatten(1)
  end

  class Frame
    def self.from_rolls rolls
      new(rolls)
    end

    attr_reader :rolls

    def initialize(rolls)
      @rolls = rolls
    end

    def base_score
      rolls.reduce(0,:+)
    end

    def score(next_frames = [])
      base_score + bonus_score(next_frames)
    end

    def to_s(final_frame_score)
      "#{final_frame_score}|#{rolls_string}"
    end

    def inspect
      padded_roll_strings.join(',')
    end

    private

    def bonus_score(next_frames)
      next_frames.flat_map(&:rolls).first(lookahead).reduce(0,:+)
    end

    def strike?
      rolls.length == 1 && all_down?
    end

    def spare?
      rolls.length == MAX_ROLLS_IN_FRAME && all_down?
    end

    def all_down?
      rolls.reduce(0,:+) == MAX_PINS
    end

    def lookahead
      strike? ? STRIKE_LOOKAHEAD : spare? ? SPARE_LOOKAHEAD : 0
    end

    def padded_roll_strings
      (rolls + Array.new(MAX_ROLLS_IN_FRAME) { '_' }).first(MAX_ROLLS_IN_FRAME)
    end

    def rolls_string
      if strike?
        'X,_'
      elsif spare?
        "#{rolls[0]},/"
      else
        padded_roll_strings.join(',')
      end
    end
  end
end
