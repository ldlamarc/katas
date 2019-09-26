# frozen_string_literal: true

require 'require_all'
require 'byebug'
require 'spec_helper'

require_all 'lib'

describe BowlingGame do
  subject(:game) { BowlingGame.new }

  context 'a new game' do
    it { is_expected.to score 0 }
  end

  context 'rolling 0' do
    before { game.roll 0 }
    it { is_expected.to score 0 }
  end

  context 'rolling 1' do
    before { game.roll 1 }
    it { is_expected.to score 1 }
  end

  context 'rolling 1 twice' do
    before { game.roll 1, 1 }
    it { is_expected.to score 2 }
  end

  context 'rolling spare-2' do
    before { game.roll 4, 6, 2 }
    it { is_expected.to score 4 + 6 + 2 + 2 }
  end

  context 'rolling strike-2-3' do
    before { game.roll 10, 2, 3 }
    it { is_expected.to score 10 + 2 + 3 + 2 + 3 }
  end

  context 'rolling 0-spare-strike-2' do
    before { game.roll 0, 10, 10, 2 }
    it { is_expected.to score 10 + 10 + 10 + 2 + 2 }
    it { expect(game.to_s).to eq '20|0,/::12|X,_::2|2,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_' }
  end

  context 'rolling strike-strike-2-3' do
    before { game.roll 10, 10, 2, 3 }
    it { is_expected.to score 10 + 10 + 2 + 10 + 2 + 3 + 2 + 3 }
  end

  context 'rolling a perfect game' do
    before { 12.times { game.roll 10 } }
    it do
      is_expected.to score 300
    end
  end

  context 'rolling a perfect game and more' do
    before { 14.times { game.roll 10 } }
    it do
      is_expected.to score 300
    end
  end
end
