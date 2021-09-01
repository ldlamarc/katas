require "ostruct"

# Did not score this one. Tried to solve C2 as well in one go so this file had the same performance issues.
# This is the fixed version. It's more simple (not able to solve C2) making it a lot easier to have good performance.

def input_array
  File.read("../io/C1.in").split("\n")[1..-1]
end

class Cave < OpenStruct
  attr_accessor :tunnel_to_exit, :mine

  def to_s
    "#{index}_#{gold}"
  end

  def max_gold
    return gold if edge?

    sorted_childrens_gold = deeper_caves.map do |option|
      option.max_gold
    end.sort

    childrens_gold = sorted_childrens_gold.last || 0
    childrens_gold += sorted_childrens_gold[-2] || 0 if exit? # because we have one drill
    childrens_gold += gold
  end

  def map_out(tunnel_to_exit = true)
    self.tunnel_to_exit = tunnel_to_exit

    deeper_tunnels.each do |tunnel|
      tunnel.map_out(self)
    end
  end

  def exit?
    tunnel_to_exit == true
  end

  def edge?
    tunnels.length < 2 && !exit?
  end

  def deeper_tunnels
    tunnels - [tunnel_to_exit].compact
  end

  def deeper_caves
    deeper_tunnels.map(&:deeper_cave)
  end
end

class Tunnel < OpenStruct
  attr_accessor :caves, :cave_to_exit, :mine

  def cave_indexes
    string.split.map(&:to_i)
  end

  def map_out(from_cave)
    self.cave_to_exit = from_cave
    deeper_cave.map_out(self)
  end

  def deeper_cave
    (caves - [cave_to_exit]).first
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
    exit_cave.max_gold
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
