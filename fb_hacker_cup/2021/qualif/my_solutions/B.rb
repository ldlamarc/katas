require "ostruct"

def input_array
  File.read("../io/B.in").split("\n")[1..-1]
end

class Cell
  attr_reader :row, :column, :value

  def initialize(row, column, value)
    @row = row
    @column = column
    @value = value
  end

  def empty?
    value == "."
  end

  def o?
    value == "O"
  end

  def x?
    value == "X"
  end

  def to_s
    "#{row}_#{column}_#{value}"
  end
end

class Line
  class << self
    def from_string(string, index)
      new(string, index)
    end

    def from_char_array(array, index)
      new(array.join, index)
    end
  end

  attr_reader :string, :line_index

  def initialize(string, index)
    @string = string
    @line_index = index
  end

  def to_s
    string
  end

  def min_x
    return if elements.any?(&:o?)

    elements.select(&:empty?).length
  end

  def set
    return [] unless min_x

    elements.select(&:empty?).sort_by(&:to_s).join("-")
  end
end

class Row < Line
  def columns
    string.chars.map.with_index do |char, index|
      Cell.new(line_index, index, char)
    end
  end

  def elements
    columns
  end
end

class Column < Line
  def rows
    string.chars.map.with_index do |char, index|
      Cell.new(index, line_index, char)
    end
  end

  def elements
    rows
  end
end

class Grid < OpenStruct
  attr_reader :columns

  def initialize(*args)
    super(*args)
    construct_columns
  end

  def n
    rows.length
  end

  def output
    output = min_x ? "#{min_x} #{nb_sets}" : "Impossible"
    "Case ##{index}: #{output}"
  end

  def min_x
    @min_x ||= lines.map(&:min_x).compact.min
  end

  def nb_sets
    return unless min_x

    @sets ||= lines.select { |line| line.min_x && line.min_x == min_x }.map(&:set).uniq.length
  end

  def lines
    rows | columns
  end

  def construct_columns
    @columns ||= n.times.map do |i|
      Column.from_char_array(rows.map { |row| row.columns[i].value }, i)
    end
  end
end

def grids
  grid = {}
  index = 1
  input_array.each_with_object([]) do |row, grids|
    if grid.empty?
      grid[:n] = row.to_i
      grid[:rows] = []
      grid[:index] = index
      index += 1
      next
    end

    if grid[:n] > 0
      grid[:rows] << Row.from_string(row, grid[:rows].length)
      grid[:n] -= 1
    end

    if grid[:n] == 0
      grids << Grid.new(grid.slice(:rows, :index))
      grid = {}
    end
  end
end

File.open("output.txt", "w+") do |file|
  grids.each do |grid|
    o = grid.output
    puts o
    file.write o
  end
  file.close
end
