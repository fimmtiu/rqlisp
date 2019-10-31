require "spec_helper"

RSpec.describe Rqlisp::Parser do
  extend DataHelpers

  TEST_CASES = {
    "integer" => [
      ['10', int(10)],
      ['-10', int(-10)],
      ['0000', int(0)],
    ],
    "string" => [
      ['"woo"', str("woo")],
      ['"w\\oo"', str("w\\oo")],
      ['"w\\"oo"', str("w\"oo")],
    ],
  }

  TEST_CASES.each do |category, subtests|
    describe category do
      subtests.each_with_index do |(source, expected), i|
        it "test #{i + 1} succeeds" do
          actual = Rqlisp::Parser.new.parse(source)
          puts "Actual: #{actual.value}"
          puts "Expect: #{expected.value}"
          expect(actual).to eq expected
        end
      end
    end
  end
end
