require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    let(:name) { 'foo' }
    let(:sell_in) { 11 }
    let(:quality) { 40 }
    let(:item) { Item.new(name, sell_in, quality) }
    let(:items) { [item] }

    before do
      GildedRose.new([item]).update_quality
    end

    it 'does not change the name' do
      expect(item.name).to eq 'foo'
    end

    context 'on normal item' do
      let(:name) { 'Elixir' }

      it 'lowers sell_in by 1' do
        expect(item.sell_in).to eq 10
      end

      it 'lowers quality by 1' do
        expect(item.quality).to eq 39
      end

      context 'after sell in date' do
        let(:sell_in) { 0 }

        it 'decreases quality by 2' do
          expect(item.quality).to eq 38
        end
      end

      context 'at quality 0' do
        let(:quality) { 0 }

        it 'does not decrease quality below 0' do
          expect(item.quality).to eq 0
        end
      end

      context 'conjured' do
        let(:name) { 'Conjured Mana Cake' }

        it 'lowers quality by 2' do
          expect(item.quality).to eq 38
        end
      end
    end

    context 'on Aged Brie' do
      let(:name) { 'Aged Brie' }

      it 'decreases sellin by 1' do
        expect(item.sell_in).to eq 10
      end

      it 'increases quality by 1' do
        expect(item.quality).to eq 41
      end

      context 'after sell in date' do
        let(:sell_in) { 0 }

        it 'increases quality by 2' do
          expect(item.quality).to eq 42
        end
      end

      context 'at quality 50' do
        let(:quality) { 50 }

        it 'does not increase quality' do
          expect(item.quality).to eq 50
        end
      end
    end

    context 'on Backstage passes' do
      let(:name) { 'Backstage passes to a TAFKAL80ETC concert' }

      it 'lowers sell_in by 1' do
        expect(item.sell_in).to eq 10
      end

      it 'increases quality by 1' do
        expect(item.quality).to eq 41
      end

      context '<= 10 days before sell in date' do
        let(:sell_in) { 10 }

        it 'increases quality by 2' do
          expect(item.quality).to eq 42
        end
      end

      context '<= 5 days before sell in date' do
        let(:sell_in) { 5 }

        it 'increases quality by 3' do
          expect(item.quality).to eq 43
        end
      end

      context '>= 0 days after sell in date' do
        let(:sell_in) { 0 }

        it 'decreases quality to 0' do
          expect(item.quality).to eq 0
        end
      end
    end

    context 'on Sulfuras' do
      let(:name) { 'Sulfuras, Hand of Ragnaros' }
      let(:quality) { 80 }

      it 'does not change sell_in' do
        expect(item.sell_in).to eq 11
      end

      it 'does not change quality (always 80)' do
        expect(item.quality).to eq 80
      end
    end
  end
end
