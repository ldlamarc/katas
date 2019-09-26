# frozen_string_literal: true

require 'roll'

class Frame
  MAX_ROLLS = 2
  MAX_PINS = Roll::MAX_PINS

  attr_accessor :rolls

  def initialize
    @rolls = []
  end

  def knock_down(pins)
    raise 'Frame is finished' unless in_progress?

    @rolls << to_roll(pins)
    @rolls.last
  end

  def score
    rolls.map(&:score).reduce(0, :+)
  end

  def in_progress?
    rolls.length < MAX_ROLLS && pins_down != MAX_PINS
  end

  def to_s
    "#{score}|#{padded_rolls.join(',')}"
  end

  def pins_down
    rolls.map(&:pins).reduce(0, :+)
  end

  def inspect
    to_s
  end

  private

  def to_roll(pins)
    return Roll.normal(pins) if pins + pins_down < MAX_PINS

    rolls.size.zero? ? Roll.strike : Roll.spare(pins)
  end

  def padded_rolls
    (@rolls | Array.new(MAX_ROLLS) { Roll.null })[0..MAX_ROLLS - 1] # Pad with no_rolls
  end
end
