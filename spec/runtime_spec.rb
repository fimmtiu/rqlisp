require "spec_helper"

RSpec.describe Rqlisp::Runtime do
  let(:env) do
    Rqlisp::Env.new(parent: nil).tap do |e|
      Rqlisp::Builtins.add_to_environment(e)
    end
  end

  describe "#run" do
    it "returns literal strings and integers" do
      expect(described_class.new.run("1")).to eq int(1)
      expect(described_class.new.run('"foo"')).to eq str("foo")
    end

    it "creates function objects from 'fn' lists" do
      expect(described_class.new.run("(fn (foo) 1)")).to eq fn(env, list(var(:foo)), list(int(1)))
    end

    it "returns quoted objects from quote" do
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
