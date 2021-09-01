class Challenge
  attr_reader :in_content, :name

  def initialize(args = {})
    @in_content = args[:in_content]
    @name = args[:name]
  end

  def input_array
    in_content.split("\n")[1..-1]
  end

  def outputs
    raise "Implement in subclass"
  end

  def write_to_file
    File.open("#{name}.submit", "w+") do |file|
      outputs.each do |output|
        o = output.output
        puts o
        file.write o
      end
      file.close
    end
  end
end
