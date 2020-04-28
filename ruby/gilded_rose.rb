class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |base_item|
      item =  ItemUpdater.new(base_item)
      item.update_state
    end
  end
end

class ItemUpdater < SimpleDelegator
  def update_state
    return if legendary?

    decrease_sell_in
    update_quality
  end

  private

    def max_quality?
      quality >= 50
    end

    def expired?
      sell_in < 0
    end

    def hot?
      hot_item? && sell_in < 10
    end

    def very_hot?
      hot_item? && sell_in < 5
    end

    def quality_increment
      increment = expired? ? 2 : 1
      increment += 1 if hot?
      increment += 1 if very_hot?
      # Assumption that appreciating items also appreciate faster if conjured
      # rationale: Brie also appreciates faster if expired
      increment *= 2 if conjured?
      increment
    end

    def update_quality
      if hot_item? && expired?
        self.quality = 0
        return
      end

      if appreciating?
        increase_quality
      else
        decrease_quality
      end
    end

    def increase_quality
      self.quality += quality_increment unless max_quality?
    end

    def decrease_quality
      self.quality -= quality_increment if quality.positive?
    end

    def decrease_sell_in
      self.sell_in -= 1
    end

    def conjured?
      name.start_with?("Conjured")
    end

    def appreciating?
      ["Aged Brie"].include?(name) || hot_item?
    end

    def hot_item?
      name.start_with?("Backstage")
    end

    def legendary?
      ["Sulfuras, Hand of Ragnaros"].include? name
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
