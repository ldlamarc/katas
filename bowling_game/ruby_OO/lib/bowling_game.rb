class BowlingGame
  MAX_FRAMES = 10

  attr_accessor :frames, :pending_bonusses

  def initialize
    @frames = Array.new(MAX_FRAMES) { |i| Frame.new }
    @pending_bonusses = []
  end

  def roll *pins
    pins.each do |pins|
      add_roll(pins)
    end
  end

  def score
    frames.map(&:score).reduce(0, :+)
  end

  def to_s
    frames.map(&:to_s).join('::')
  end

  def inspect
    to_s
  end

  private

  def in_progress?
    frame_in_progress || pending_bonusses.any?
  end

  def add_roll(pins)
    if in_progress?
      new_roll = Roll.from_pins(pins)
      update_bonusses(new_roll)
      frame_in_progress.add_roll(new_roll) if frame_in_progress
    end
  end

  def frame_in_progress
    frames.find(&:in_progress?)
  end

  def calculate_generated_bonus(frame_in_progress, roll)
    return RollBonus.strike if roll.going_to_strike?(frame_in_progress)
    return RollBonus.spare if roll.going_to_spare?(frame_in_progress)
    RollBonus.null
  end

  def applicable_bonusses
    pending_bonusses.reject(&:maxed?)
  end

  def update_bonusses(roll)
    applicable_bonusses.map { |bonus| bonus.rolls << roll }
    if frame_in_progress
      generated_bonus = calculate_generated_bonus(frame_in_progress, roll)
      roll.generated_bonus = generated_bonus
      pending_bonusses << generated_bonus
    end
  end
end
