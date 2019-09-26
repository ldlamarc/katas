# frozen_string_literal: true

class BowlingGame
  MAX_FRAMES = 10

  attr_reader :frames

  def initialize
    @frames = MAX_FRAMES.times.map { Frame.new }
    @bonusses = []
  end

  def roll(*pins)
    pins.each do |pin|
      add_roll(pin)
    end
  end

  def score
    frames.map(&:score).reduce(0, :+)
  end

  def in_progress?
    frame_in_progress || unused_bonusses.any?
  end

  def frame_in_progress
    frames.find(&:in_progress?)
  end

  def unused_bonusses
    bonusses.reject(&:used?)
  end

  def to_s
    frames.map(&:to_s).join('::')
  end

  def inspect
    to_s
  end

  private

  attr_writer :frames
  attr_accessor :bonusses

  def add_roll(pins)
    return unless in_progress?

    roll = frame_in_progress&.knock_down(pins) || bonus_roll(pins)
    unused_bonusses.map { |bonus| bonus.register(roll) }
    bonusses << roll.bonus
  end

  def bonus_roll(pins)
    Roll.normal(pins)
  end
end
