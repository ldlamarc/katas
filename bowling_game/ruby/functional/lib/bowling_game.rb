# frozen_string_literal: true

module BowlingGame
  MAX_PINS = 10
  MAX_ROLLS_IN_FRAME = 2
  STRIKE_LOOKAHEAD = 2
  SPARE_LOOKAHEAD = 1
  BONUS_LOOKAHEADS = [STRIKE_LOOKAHEAD, SPARE_LOOKAHEAD].freeze
  MAX_FRAMES = 10

  # A chunk is a frame + consequent frames affecting bonus
  # Each chunk can be processed in parallel, for each frame there is a chunk

  def score_bowling_game_rolls(rolls)
    padded_rolls = pad_rolls(rolls)
    frames = map_to_frames(padded_rolls)
    chunks = map_to_chunks(frames)
    chunks.map { |chunk| chunk_to_score(chunk) }.sum(&:to_i)
  end

  def to_s_bowling_game_rolls(rolls)
    padded_rolls = pad_rolls(rolls)
    frames = map_to_frames(padded_rolls)
    chunks = map_to_chunks(frames)
    chunks.map { |chunk| chunk_to_s(chunk) }.join('::')
  end

  private

  def pad_rolls(rolls)
    max_rolls = MAX_FRAMES * MAX_ROLLS_IN_FRAME + BONUS_LOOKAHEADS.max
    pad(rolls, nil, max_rolls)
  end

  def pad(array, pad_value, length)
    (array + Array.new(length) { pad_value }).first(length)
  end

  def map_to_frames(rolls)
    # A new frame always begins after a MAX_PINS roll
    rolls.slice_after(MAX_PINS).map do |el|
      # A new frame begins after MAX_ROLLS_IN_FRAME number of rolls
      el.each_slice(MAX_ROLLS_IN_FRAME).to_a
    end.flatten(1).first(MAX_FRAMES + BONUS_LOOKAHEADS.max)
  end

  # A chunk is a frame + consequent frames affecting bonus
  # Each chunk can be processed in parallel
  def map_to_chunks(frames)
    frames.each_cons(1 + BONUS_LOOKAHEADS.max).to_a
  end

  def chunk_to_score(chunk)
    frame = chunk[0]
    frame.sum(&:to_i) + bonus_score(chunk)
  end

  def chunk_to_s(chunk)
    "#{chunk_to_score(chunk)}|#{frame_roll_strings(chunk[0]).join(',')}"
  end

  def frame_roll_strings(frame)
    return pad(['X'], '_', MAX_ROLLS_IN_FRAME) if strike?(frame)

    rolls = frame.map { |roll| roll ? roll.to_s : '_' }
    spare?(frame) ? pad(rolls[0..-2], '/', MAX_ROLLS_IN_FRAME) : rolls
  end

  def bonus?(frame)
    frame.sum(&:to_i) == MAX_PINS
  end

  def strike?(frame)
    bonus?(frame) && frame.size == 1
  end

  def spare?(frame)
    bonus?(frame) && frame.size > 1
  end

  def bonus_score(chunk)
    frame = chunk[0]
    return 0 unless bonus?(frame)

    lookahead = strike?(frame) ? STRIKE_LOOKAHEAD : SPARE_LOOKAHEAD
    chunk.drop(1).flatten.first(lookahead).sum(&:to_i)
  end
end
