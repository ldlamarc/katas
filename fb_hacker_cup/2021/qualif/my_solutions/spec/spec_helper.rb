# frozen_string_literal: true

require "timeout"
require "byebug"
require_relative "../autoload"

RSpec::Matchers.define :output_same_as do |test_file, focus|
  match do |outputs|
    matches(outputs, test_file, focus).all? { |assertion| assertion[0] }
  end

  def expected_outputs(test_file)
    test_file.split("\n")
  end

  def timed_output(output)
    @timed_outputs ||= {}
    @timed_outputs[output.index] ||= begin
      Timeout.timeout(3) { output.output }
    rescue Timeout::Error
      "timed out at 3 seconds"
    end
  end

  def matches(outputs, test_file, focus)
    already_failed = false
    outputs.map.with_index(1) do |output, index|
      expected = expected_outputs(test_file)[index - 1]

      matches = true
      matches = (timed_output(output) == expected) unless (focus && focus != index) || already_failed
      already_failed = true if matches != true

      [matches, index, output, expected]
    end
  end

  def format_failure(failure, debug = false)
    basic = "#{failure[3]} (expected)\r\n"\
      "#{timed_output(failure[2])} (got)\r\n"\
      "#{"Debug:\r\n #{failure[2].debug}\r\n" if debug}"
  end

  failure_message do |outputs|
    failures = matches(outputs, test_file, focus).select { |assertion| assertion[0] != true }
    format_failure(failures.first, true)
    failures.map.with_index do |failure, index|
      format_failure(failure, index == 0)
    end.join("\r\n")
  end

  description do
    "match test cases"
  end
end
