require "spec_helper"

RSpec.describe Rqlisp::Runtime do
  describe "#run" do
    it "returns literal strings and integers" do
      expect(described_class.new.run("1")).to eq int(1)
      expect(described_class.new.run('"foo"')).to eq str("foo")
    end

    it "creates function objects from 'fn' lists" do
      func = fn(an_instance_of(Rqlisp::Env), list(var(:foo)), list(int(1)))
      expect(described_class.new.run("(fn (foo) 1)")).to eq func
    end

    it "returns quoted objects from 'quote'" do
      expect(described_class.new.run("(quote (1))")).to eq list(int(1))
    end

    it "applies builtin functions" do
      expect(described_class.new.run("(+ 1 2)")).to eq int(3)
    end

    it "applies functions defined by 'fn'" do
      expect(described_class.new.run("((fn (i) (+ i 3)) 1)")).to eq int(4)
    end
  end
end
