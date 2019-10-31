require "spec_helper"

RSpec.describe Rqlisp::List do
  it "doesn't allow dotted lists" do
    expect do
      described_class.new(int(1), int(2))
    end.to raise_error(/Dotted lists/)
  end

  describe "#to_array" do
    it "returns the correct array representation" do
      expect(list().to_array).to eq []
      expect(list(int(1)).to_array).to eq [int(1)]
      expect(list(int(1), int(2)).to_array).to eq [int(1), int(2)]
      expect(list(int(1), list(int(2))).to_array).to eq [int(1), list(int(2))]
    end
  end

  describe "#to_s" do
    it "returns a valid string representation" do
      expect(list().to_s).to eq "()"
      expect(list(int(1)).to_s).to eq "(1)"
      expect(list(int(1), int(2)).to_s).to eq "(1 2)"
      expect(list(int(1), list(int(2))).to_s).to eq "(1 (2))"
    end
  end
end
