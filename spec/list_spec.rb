require "spec_helper"

RSpec.describe Rqlisp::List do
  it "doesn't allow dotted lists" do
    expect do
      described_class.new(int(1), int(2))
    end.to raise_error(/must be nil or another list/)
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

  describe "#[]=" do
    let(:stuff) { list(int(1), int(2), int(3)) }

    it "sets the first element of a list" do
      expect do
        stuff[0] = int(31337)
      end.to change { stuff.to_s }.from("(1 2 3)").to("(31337 2 3)")
    end

    it "sets subsequent elements of a list" do
      expect do
        stuff[2] = int(31337)
      end.to change { stuff.to_s }.from("(1 2 3)").to("(1 2 31337)")
    end

    it "raises errors for out-of-range indexes" do
      expect { list()[0] = int(1) }.to raise_error(/index 0 out of range \[0..0\)/)
      expect { list(int(2))[1] = int(1) }.to raise_error(/index 1 out of range \[0..1\)/)
      expect { list(int(2))[-1] = int(1) }.to raise_error(/index -1 out of range \[0..1\)/)
    end
  end

  describe "#each" do
    let(:stuff) { list(int(1), int(2), int(3)) }

    it "iterates over the list" do
      items = []
      stuff.each { |item| items << item }
      expect(items).to eq stuff.to_array
    end
  end
end
