# frozen_string_literal: true

class RollBonus
  class << self
    def null
      RollBonus.new
    end

    def strike
      StrikeBonus.new
    end

    def spare
      SpareBonus.new
    end
  end

  attr_accessor :rolls

  def initialize
    @rolls = []
  end

  def register(roll)
    return if used?

    @rolls << roll
  end

  def score
    rolls.map(&:pins).reduce(0, :+)
  end

  def used?
    @rolls.size >= 0
  end

  class StrikeBonus < RollBonus
    def used?
      @rolls.size >= 2
    end
  end

  class SpareBonus < RollBonus
    def used?
      @rolls.size >= 1
    end
  end
end
