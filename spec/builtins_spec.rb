require "spec_helper"

RSpec.describe Rqlisp::Builtins do
  describe ".addition" do
    it "adds numbers together" do
      expect(Rqlisp::Runtime.new.run("(+ 1 2)")).to eq int(3)
    end
  end

  describe ".print" do
    it "prints the representation of an object to stdout" do
      expect(described_class).to receive(:puts).with("(1 2)")
      expect(Rqlisp::Runtime.new.run("(print '(1 2))")).to eq Rqlisp::NIL
    end
  end

  describe ".less_than" do
    it "returns true when a is < b" do
      expect(Rqlisp::Runtime.new.run("(< 1 2)")).to eq Rqlisp::TRUE
    end

    it "returns false when a is >= b" do
      expect(Rqlisp::Runtime.new.run("(< 2 2)")).to eq Rqlisp::FALSE
    end
  end

  describe ".greater_than" do
    it "returns true when a is > b" do
      expect(Rqlisp::Runtime.new.run("(> 2 1)")).to eq Rqlisp::TRUE
    end

    it "returns false when a is <= b" do
      expect(Rqlisp::Runtime.new.run("(> 2 2)")).to eq Rqlisp::FALSE
    end
  end
end
