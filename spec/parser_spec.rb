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
      ["(1\n2)", list(int(1), int(2))],
      ['("one" "two" "three")', list(str("one"), str("two"), str("three"))],
    ],
    "comment" => [
      ['"woo" ; "hoo"', str("woo")],
      ['"woo" ;; "hoo"', str("woo")],
      [';(1 2)', nil],
      ["; i like pie\n(1 2)", list(int(1), int(2))],
    ],
    "multiple things" => [
      ["1 2 3", [int(1), int(2), int(3)]],
    ],
    "variable" => [
      ['honk', var("honk")],
      ['honk', var(:honk)],
    ],
  }

  TEST_CASES.each do |category, subtests|
    describe category do
      subtests.each_with_index do |(source, expected), i|
        wrapped_expected = expected.nil? ? list() : list(*expected)
        it "test #{i + 1} succeeds" do
          actual = Rqlisp::Parser.new.parse(source)
          expect(actual).to eq wrapped_expected
        end
      end
    end
  end
end
