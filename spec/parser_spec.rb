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
    "list" => [
      ['()', list()],
      ['(1 2)', list(int(1), int(2))],
    ],
    "comments" => [
      ['"woo" ;; woo woo', str("woo")],
      [';(1 2)', nil],
      ['; i like pie\n(1 2)', list(int(1), int(2))],
    ],
  }

  TEST_CASES.each do |category, subtests|
    describe category do
      subtests.each_with_index do |(source, expected), i|
        it "test #{i + 1} succeeds" do
          actual = Rqlisp::Parser.new.parse(source)
          expect(actual).to eq expected
        end
      end
    end
  end
end
