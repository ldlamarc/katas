require "ostruct"

def input_array
  File.read("../io/A2.in").split("\n")[1..-1]
end

class Replacement
  attr_reader :source, :target, :effort

  class << self
    def from_string(string, effort)
      new(string[0], string[1], effort)
    end
  end

  def initialize(source, target, effort)
    @source = source
    @target = target
    @effort = effort
  end

  def to_s
    "#{source}#{target}"
  end

  def +(other)
    return if target != other.source

    Replacement.new(source, other.target, effort + other.effort)
  end
end

class Birthday < OpenStruct
  def initialize(*args)
    super(*args)
    @all_min_replacements = replacements.map(&:to_s).zip(replacements).to_h
    calculate_all_min_replacements
  end

  def output
    "Case ##{index}: #{min_effort}\n"
  end

  private

    attr_accessor :all_min_replacements

    def combine_rep(source)
      all_min_replacements.to_a.each do |_, target|
        new_rep = source + target
        existing_rep = all_min_replacements[new_rep.to_s]
        next unless new_rep && (!existing_rep || new_rep.effort < existing_rep.effort)

        @all_min_replacements[new_rep.to_s] = new_rep
        combine_rep(new_rep)
      end
    end

    def calculate_all_min_replacements
      replacements.each do |source|
        combine_rep(source)
      end
    end

    def min_effort_letter(source, target)
      return 0 if source == target
      return -1 unless all_min_replacements["#{source}#{target}"]

      all_min_replacements["#{source}#{target}"].effort
    end

    def effort(target_letter)
      efforts = string.chars.to_a.map { |source| min_effort_letter(source, target_letter) }
      return nil if efforts.any? { |effort| effort == -1 }

      efforts.reduce(:+)
    end

    def min_effort
      @min_effort ||= ("A".."Z").map { |letter| effort(letter) }.compact.min || -1
    end
end

def birthdays
  birthday = {}
  index = 1
  input_array.each_with_object([]) do |row, birthdays|
    if birthday.empty?
      birthday[:string] = row
      birthday[:index] = index
      index += 1
      next
    end
    if !birthday[:nb_replacements]
      birthday[:nb_replacements] = row.to_i
      birthday[:replacements] = []
    elsif birthday[:nb_replacements] > 0
      birthday[:replacements] << Replacement.from_string(row, 1)
      birthday[:nb_replacements] -= 1
    end

    if birthday[:nb_replacements] == 0
      birthdays << Birthday.new(birthday)
      birthday = {}
    end
  end
end

File.open("output.txt", "w+") do |file|
  birthdays.each do |birthday|
    o = birthday.output
    puts o
    file.write o
  end
  file.close
end
