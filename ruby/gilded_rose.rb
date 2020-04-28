class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |base_item|
      item =  ItemUpdater.new(base_item)
      item.decrease_sell_in
      item.update_quality
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

  def hot?
    sell_in < 10
  end

  def very_hot?
    sell_in < 5
  end

  def quality_increment
    increment = expired? ? 2 : 1
    increment += 1 if hot? && backstage_pass?
    increment += 1 if very_hot? && backstage_pass?
    increment
  end

  def update_quality
    if backstage_pass? && expired?
      self.quality = 0
      return
    end

    if aged_brie? or backstage_pass?
      increase_quality
    else
      decrease_quality
    end
  end

  def increase_quality
    self.quality += quality_increment unless max_quality?
  end

  def decrease_quality
    return if sulfuras?

    self.quality -= quality_increment if quality.positive?
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
