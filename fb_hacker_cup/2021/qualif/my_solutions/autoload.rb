require "zeitwerk"

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__.to_s)
loader.push_dir("lib")
loader.setup
