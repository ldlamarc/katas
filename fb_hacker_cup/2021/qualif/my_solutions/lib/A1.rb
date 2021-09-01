VOWELS = %w[A E I O U]

def input_array
  File.read("../io/A1.in").split("\n")[1..-1]
end

def effort_letter(source, target)
  return 0 if source == target

  both_vowels = VOWELS.include?(source) && VOWELS.include?(target)
  both_cons = !VOWELS.include?(source) && !VOWELS.include?(target)
  return 2 if both_vowels || both_cons

  1
end

def effort(string, target_letter)
  string.chars.to_a.map { |source| effort_letter(source, target_letter) }.reduce(:+)
end

def min_effort(string)
  ("A".."Z").map { |letter| effort(string, letter) }.min
end

def format_effort(string, index)
  "Case ##{index}: #{min_effort(string)}\n"
end

output = input_array.map.with_index { |string, index| format_effort(string, index + 1) }
puts output

File.open("output.txt", "w+") do |file|
  output.each do |output_case|
    file.write output_case
  end
  file.close
end
