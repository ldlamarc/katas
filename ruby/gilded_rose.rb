class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |base_item|
      item =  ItemUpdater.new(base_item)

      unless item.aged_brie? or item.backstage_pass?
        if item.quality > 0
          unless item.sulfuras?
            item.quality = item.quality - 1
          end
        end
      else
        unless item.max_quality?
          item.quality = item.quality + 1
          if item.backstage_pass?
            if item.sell_in < 11
              unless item.max_quality?
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              unless item.max_quality?
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      unless item.sulfuras?
        item.sell_in = item.sell_in - 1
      end
      if item.expired?
        unless item.aged_brie?
          unless item.backstage_pass?
            if item.quality > 0
              unless item.sulfuras?
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          unless item.max_quality?
            item.quality = item.quality + 1
          end
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
