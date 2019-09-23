# frozen_string_literal: true

class Roll
  MIN_PINS = 0
  MAX_PINS = 10

  class << self
    def from_pins(pins)
      new(pins)
    end

    def null
      NoRoll.new
    end
  end

  attr_reader :pins
  attr_writer :generated_bonus

  def initialize(pins)
    raise 'not a valid number of pins' unless (MIN_PINS..MAX_PINS).include? pins

    @pins = pins
  end

  def score
    pins + generated_bonus.bonus_score
  end

  def strike?(frame)
    frame.strike?(self)
  end

  def spare?(frame)
    frame.spare?(self)
  end

  def going_to_strike?(frame)
    frame.no_rolls_made_yet? && brings_all_pins_down?(frame)
  end

  def going_to_spare?(frame)
    !frame.no_rolls_made_yet? && brings_all_pins_down?(frame)
  end

  def max_pins?
    pins == MAX_PINS
  end

  def to_s(frame = Frame.null)
    return 'X' if strike?(frame)

    return '/' if spare?(frame)

    pins.to_s
  end

  def inspect
    to_s
  end

  def generated_bonus
    @generated_bonus || RollBonus.null
  end

  private

  def brings_all_pins_down?(frame)
    frame.pins_down + pins == MAX_PINS
  end

  class NoRoll
    def pins
      0
    end

    def score
      0
    end

    def to_s(_frame)
      '_'
    end
  end
end
