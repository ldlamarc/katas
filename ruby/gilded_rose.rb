class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |base_item|
      item =  ItemUpdater.new(base_item)

      item.decrease_sell_in

      unless item.aged_brie? or item.backstage_pass?
        item.decrease_quality
      else
        unless item.max_quality?
          item.increase_quality
          if item.backstage_pass?
            if item.sell_in < 10
              item.increase_quality
            end
            if item.sell_in < 5
              item.increase_quality
            end
          end
        end
      end
      if item.expired?
        unless item.aged_brie?
          unless item.backstage_pass?
            item.decrease_quality
          else
            item.quality = 0
          end
        else
          item.increase_quality
        end
      end
    end
  end
end

class ItemUpdater < SimpleDelegator
  def max_quality?
    quality >= 50
  end

  def expired?
    sell_in < 0
  end

  def increase_quality
    self.quality += 1 unless max_quality?
  end

  def decrease_quality
    self.quality -= 1 unless sulfuras? || quality <= 0
  end

  def decrease_sell_in
    return if sulfuras?

    self.sell_in -= 1
  end

  def aged_brie?
    name == "Aged Brie"
  end

  def backstage_pass?
    name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def sulfuras?
    name == "Sulfuras, Hand of Ragnaros"
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
