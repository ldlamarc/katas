# frozen_string_literal: true

require "timeout"
require "byebug"
require_relative "../autoload"

RSpec::Matchers.define :output_same_as do |test_file|
  match do |challenge|
    matches(challenge, test_file).all? { |assertion| assertion[0] }
  end

  def expected_outputs(test_file)
    test_file.split("\n")
  end

  def timed_output(output, focus = false)
    @timed_outputs ||= {}
    @timed_outputs[output.index] ||= begin
      if focus
        output.output
      else
        Timeout.timeout(3) { output.output }
      end
    rescue Timeout::Error
      "timed out at 3 seconds"
    end
  end

  def matches(challenge, test_file)
    already_failed = false
    challenge.outputs.map.with_index(1) do |output, index|
      expected = expected_outputs(test_file)[index - 1]
      focus = challenge.focus && challenge.focus == index
      other_focus = challenge.focus && challenge.focus != index
      matches = true
      matches = (timed_output(output, focus) == expected) unless other_focus || already_failed
      already_failed = true if matches != true

      [matches, index, output, expected, challenge.focus]
    end
  end

  def format_failure(failure)
    basic = "#{failure[3]} (expected)\r\n"\
      "#{timed_output(failure[2])} (got)\r\n"\
      "Debug:\r\n #{failure[2].debug}\r\n"\
      "==========="
  end

  failure_message do |challenge|
    failures = matches(challenge, test_file).select { |assertion| assertion[0] != true }
    failures.map.with_index do |failure, _index|
      format_failure(failure)
    end.join("\r\n")
  end

  description do
    "match test cases"
  end
end
