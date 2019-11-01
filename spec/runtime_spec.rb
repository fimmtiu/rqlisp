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

    it "evals unique constants specially" do
      expect(described_class.new.run("true")).to eq Rqlisp::TRUE
      expect(described_class.new.run("false")).to eq Rqlisp::FALSE
      expect(described_class.new.run("nil")).to eq Rqlisp::NIL
    end

    it "applies builtin functions" do
      expect(described_class.new.run("(+ 1 2)")).to eq int(3)
    end

    it "applies functions defined by 'fn'" do
      expect(described_class.new.run("((fn (i) (+ i 3)) 1)")).to eq int(4)
    end

    describe "if" do
      it "calls the first branch if the condition is true" do
        expect(described_class.new.run("(if true 1 2)")).to eq int(1)
      end

      it "calls the first branch if the condition is true-ish" do
        expect(described_class.new.run("(if 31337 1 2)")).to eq int(1)
      end

      it "returns nil if the condition is false but there's no second branch" do
        expect(described_class.new.run("(if false 1)")).to eq Rqlisp::NIL
      end

      it "calls the second branch if the condition is false" do
        expect(described_class.new.run("(if false 1 2)")).to eq int(2)
      end

      it "calls the second branch if the condition is nil" do
        expect(described_class.new.run("(if nil 1 2)")).to eq int(2)
      end
    end

    describe "defmacro" do
      it "creates a new macro with the given name in the current env" do
        macro = described_class.new.run('(defmacro foo () 1) foo')
        expect(macro).to be_a Rqlisp::Macro
      end
    end
  end
end
