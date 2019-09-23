# frozen_string_literal: true

require 'roll'

class Frame
  MAX_ROLLS = 2
  MAX_PINS = Roll::MAX_PINS

  attr_accessor :rolls

  def initialize
    @rolls = []
  end

  def add_roll(roll)
    @rolls << roll
  end

  def score
    rolls.map(&:score).reduce(0, :+)
  end

  def in_progress?
    rolls.length < MAX_ROLLS && !all_pins_down?
  end

  def strike?(roll)
    first_registered_roll?(roll) && roll.max_pins?
  end

  def spare?(roll)
    all_pins_down? && !first_registered_roll?(roll)
  end

  def to_s
    "#{score}|#{padded_rolls.map { |roll| roll.to_s(self) }.join(',')}"
  end

  def no_rolls_made_yet?
    rolls.empty?
  end

  def pins_down
    rolls.map(&:pins).reduce(0, :+)
  end

  def inspect
    to_s
  end

  private

  def padded_rolls
    (@rolls | Array.new(MAX_ROLLS) { Roll.null })[0..MAX_ROLLS - 1] # Pad with no_rolls
  end

  def all_pins_down?
    pins_down == MAX_PINS
  end

  def first_registered_roll?(roll)
    rolls.first == roll
  end
end
