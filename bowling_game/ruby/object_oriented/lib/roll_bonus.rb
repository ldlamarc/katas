# frozen_string_literal: true

class RollBonus
  MAX_ROLLS = 1

  class << self
    def null
      NoBonus.new
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

  def bonus_score
    rolls.map { |roll| bonus_score_for_roll(roll) }.reduce(0, :+)
  end

  def maxed?
    rolls.length >= self.class::MAX_ROLLS
  end

  class NoBonus < RollBonus
    MAX_ROLLS = 0

    def bonus_score_for_roll(_roll)
      0
    end
  end

  class DoubleScoreBonus < RollBonus
    def bonus_score_for_roll(roll)
      roll.pins
    end
  end

  class StrikeBonus < DoubleScoreBonus
    MAX_ROLLS = 2
  end

  class SpareBonus < DoubleScoreBonus; end
end
