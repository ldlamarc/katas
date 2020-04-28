class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      unless aged_brie?(item) or backstage_pass?(item)
        if item.quality > 0
          unless sulfuras?(item)
            item.quality = item.quality - 1
          end
        end
      else
        unless max_quality?(item)
          item.quality = item.quality + 1
          if backstage_pass?(item)
            if item.sell_in < 11
              unless max_quality?(item)
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              unless max_quality?(item)
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      unless sulfuras?(item)
        item.sell_in = item.sell_in - 1
      end
      if expired?(item)
        unless aged_brie?(item)
          unless backstage_pass?(item)
            if item.quality > 0
              unless sulfuras?(item)
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          unless max_quality?(item)
            item.quality = item.quality + 1
          end
        end
      end
    end
  end
end

def max_quality?(item)
  item.quality >= 50
end

def expired?(item)
  item.sell_in < 0
end

def aged_brie?(item)
  item.name == "Aged Brie"
end

def backstage_pass?(item)
  item.name == "Backstage passes to a TAFKAL80ETC concert"
end

def sulfuras?(item)
  item.name == "Sulfuras, Hand of Ragnaros"
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
