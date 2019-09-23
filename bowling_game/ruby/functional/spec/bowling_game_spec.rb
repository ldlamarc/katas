# frozen_string_literal: true

require 'require_all'
require 'spec_helper'
require_all 'lib'

describe BowlingGame do
  describe '#score' do
    subject { BowlingGame.roll(*rolls).score }

    context 'a new game' do
      let(:rolls) { [] }
      it { is_expected.to eq 0 }
    end

    context 'rolling 0' do
      let(:rolls) { [0] }
      it { is_expected.to eq 0 }
    end

    context 'rolling 1' do
      let(:rolls) { [1] }
      it { is_expected.to eq 1 }
    end

    context 'rolling 1 twice' do
      let(:rolls) { [1, 1] }
      it { is_expected.to eq 2 }
    end

    context 'rolling spare-2' do
      let(:rolls) { [4, 6, 2] }
      it { is_expected.to eq 4 + 6 + 2 + 2 }
    end

    context 'rolling strike-2-3' do
      let(:rolls) { [10, 2, 3] }
      it { is_expected.to eq 10 + 2 + 3 + 2 + 3 }
    end

    context 'rolling 0-spare-strike-2' do
      let(:rolls) { [0, 10, 10, 2] }
      it { is_expected.to eq 10 + 10 + 10 + 2 + 2 }
    end

    context 'rolling strike-strike-2-3' do
      let(:rolls) { [10, 10, 2, 3] }
      it { is_expected.to eq 10 + 10 + 2 + 10 + 2 + 3 + 2 + 3 }
    end

    context 'rolling a perfect game' do
      let(:rolls) { Array.new(12) { 10 } }
      it { is_expected.to eq 300 }
    end

    context 'rolling a perfect game and more' do
      let(:rolls) { Array.new(14) { 10 } }
      it { is_expected.to eq 300 }
    end
  end

  describe '#to_s' do
    subject { BowlingGame.roll(*rolls).to_s }

    context 'rolling 0-spare-strike-2' do
      let(:rolls) { [0, 10, 10, 2] }
      it { is_expected.to eq '20|0,/::12|X,_::2|2,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_::0|_,_' }
    end
  end
end
