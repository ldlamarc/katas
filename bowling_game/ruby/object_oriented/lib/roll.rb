# frozen_string_literal: true

class Roll
  MIN_PINS = 0
  MAX_PINS = 10

  class << self
    def strike
      Strike.new(MAX_PINS)
    end

    def spare(pins)
      Spare.new(pins)
    end

    def normal(pins)
      new(pins)
    end

    def null
      Null.new(MIN_PINS)
    end
  end

  attr_reader :pins

  def initialize(pins)
    raise 'not a valid number of pins' unless (MIN_PINS..MAX_PINS).include? pins

    @pins = pins
  end

  def score
    pins + bonus.score
  end

  def spare?
    false
  end

  def strike?
    false
  end

  def to_s
    pins.to_s
  end

  def inspect
    to_s
  end

  def bonus
    @bonus ||= RollBonus.null
  end

  class Strike < Roll
    def strike?
      true
    end

    def to_s
      'X'
    end

    def bonus
      @bonus ||= RollBonus.strike
    end
  end

  class Spare < Roll
    def spare?
      true
    end

    def to_s
      '/'
    end

    def bonus
      @bonus ||= RollBonus.spare
    end
  end

  class Null < Roll
    def to_s
      '_'
    end
  end
end
