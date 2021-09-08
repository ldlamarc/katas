require "spec_helper"

describe "C2" do
  subject { C2.new(name: "C2", in_content: File.read("../io/C2.in")) }

  it do
    is_expected.to output_same_as File.read("../io/C2.out")
    subject.write_to_file
  end
end
