require "ostruct"
require "byebug"

# Did not score this one

def input_array
  File.read("../io/C1.in").split("\n")[1..-1]
end

class Cave < OpenStruct
  attr_accessor :tunnel_to_exit, :mine

  def to_s
    "#{index}_#{gold}"
  end

  def max_gold(drills, visited_caves, visited_tunnels)
    possible_options = possible_options(drills, visited_caves, visited_tunnels)
    return 0 if possible_options.empty? && !exitable?(visited_caves, visited_tunnels)
    return visited_caves.map(&:gold).reduce(:+) if possible_options.empty?

    possible_options.map do |option|
      drills_left = option.is_a?(Tunnel) ? drills : drills - 1
      option.max_gold(drills_left, visited_caves | [self], visited_tunnels)
    end.max || 0
  end

  def map_out(tunnel_to_exit = true)
    self.tunnel_to_exit = tunnel_to_exit

    deeper_tunnels.each do |tunnel|
      tunnel.map_out(self)
    end
  end

  def edge?
    tunnels.length < 2
  end

  def gold_to_top(visited_caves)
    gold_left = visited_caves.include?(self) ? 0 : gold
    tunnel_to_exit == true ? gold_left : gold_left + tunnel_to_exit.cave_to_exit.gold_to_top(visited_caves)
  end

  def deeper_tunnels
    tunnels - [tunnel_to_exit].compact
  end

  def exitable?(visited_caves, visited_tunnels)
    tunnel_to_exit == true || tunnel_to_exit.exitable?(visited_caves, visited_tunnels)
  end

  def deeper_caves
    deeper_tunnels.map(&:deeper_cave)
  end

  def possible_options(drills, visited_caves, visited_tunnels)
    interesting_caves = (mine.caves.select(&:edge?) - visited_caves) | [mine.exit_cave]
    drillable_caves = drills > 0 && edge? ? [interesting_caves.max_by { |cave| cave.gold_to_top(visited_caves) }] : []
    explorable_tunnels = tunnels - visited_tunnels
    drillable_caves | explorable_tunnels
  end
end

class Tunnel < OpenStruct
  attr_accessor :caves, :cave_to_exit, :mine

  def cave_indexes
    string.split.map(&:to_i)
  end

  def exitable?(visited_caves, visited_tunnels)
    !visited_tunnels.include?(self) && cave_to_exit.exitable?(visited_caves, visited_tunnels)
  end

  def map_out(from_cave)
    self.cave_to_exit = from_cave
    deeper_cave.map_out(self)
  end

  def deeper_cave
    (caves - [cave_to_exit]).first
  end

  def max_gold(drills, visited_caves, visited_tunnels)
    return 0 if possible_options(drills, visited_caves, visited_tunnels).empty?

    possible_options(drills, visited_caves, visited_tunnels).map do |option|
      option.max_gold(drills, visited_caves, visited_tunnels | [self])
    end.max
  end

  def possible_options(_drills, _visited_caves, _visited_tunnels)
    caves
  end

  def to_s
    string
  end
end

class Mine < OpenStruct
  class << self
    def from_strings(args = {})
      tunnels = args[:tunnels].map { |string| Tunnel.new(string: string) }

      caves = args[:caves].split.map.with_index(1) do |gold, index|
        tunnels_of_cave = tunnels.select { |tunnel| tunnel.cave_indexes.include? index }
        Cave.new(gold: gold.to_i, index: index, tunnels: tunnels_of_cave)
      end

      tunnels.each do |tunnel|
        tunnel.caves = caves.select { |cave| tunnel.cave_indexes.include? cave.index }
      end

      mine = new(caves: caves, tunnels: tunnels, index: args[:index], drills: args[:drills])
      (caves | tunnels).each { |object| object.mine = mine }
      mine.map_out

      mine
    end
  end

  def exit_cave
    caves[0]
  end

  def map_out
    exit_cave.map_out
  end

  def debug
    "#{index} #{caves.map(&:to_s).join(' ')} #{tunnels.map(&:to_s).join('_')}"
  end

  def output
    "Case ##{index}: #{max_gold}\n"
  end

  def max_gold
    exit_cave.max_gold(drills, [], [])
  end
end

def mines
  mine = {}
  index = 1
  input_array.each_with_object([]) do |row, mines|
    cave_set = false
    if mine.empty?
      mine[:n_tunnels] = row.to_i - 1
      mine[:drills] = 1
      mine[:caves] = []
      mine[:tunnels] = []
      mine[:index] = index
      index += 1
      next
    end

    if mine[:caves].empty?
      mine[:caves] = row
      cave_set = true
    end

    if mine[:n_tunnels] > 0 && !cave_set
      mine[:tunnels] << row
      mine[:n_tunnels] -= 1
    end

    if mine[:n_tunnels] == 0
      mines << Mine.from_strings(mine.slice(:tunnels, :caves, :index, :drills))
      mine = {}
    end
  end
end

File.open("output.txt", "w+") do |file|
  mines.each do |mine|
    o = mine.output
    puts o
    file.write o
  end
  file.close
end
