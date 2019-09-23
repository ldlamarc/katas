# frozen_string_literal: true

RSpec::Matchers.define :score do |expected_score|
  match do |game|
    game.score == expected_score
  end

  failure_message do |game|
    "expected game to score #{expected_score}, but it scored #{game.score}\r\n"\
      "state was: #{game.frames}"
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end
