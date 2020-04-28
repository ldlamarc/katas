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

    def hotness_increment
      return 0 unless hot_item?
      return 2 if sell_in < 5

      sell_in < 10 ? 1 : 0
    end

    def quality_increment
      return -quality if hot_item? && expired?

      increment = expired? ? 2 : 1
      increment += hotness_increment
      # Assumption that appreciating items also appreciate faster if conjured
      # rationale: Brie also appreciates faster if expired
      increment *= 2 if conjured?
      increment
    end

    def update_quality
      if appreciating?
        increase_quality
      else
        decrease_quality
      end

      cutoff
    end

    def increase_quality
      self.quality += quality_increment
    end

    def decrease_quality
      self.quality -= quality_increment
    end

    def cutoff
      self.quality = 0 if quality.negative?
      self.quality = 50 if max_quality?
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
