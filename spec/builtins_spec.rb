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
      expect(Rqlisp::Runtime.new.run("(print '(1 2))")).to eq Rqlisp::TRUE
    end
  end
end
