require "spec_helper"

RSpec.describe Rqlisp::Runtime do
  let(:env) do
    Rqlisp::Env.new(parent: nil).tap do |e|
      Rqlisp::Builtins.add_to_environment(e)
    end
  end

  describe "#eval" do
    it "returns literal strings and integers" do
      expect(described_class.new.eval(int(1), env)).to eq int(1)
      expect(described_class.new.eval(str("foo"), env)).to eq str("foo")
    end

    it "creates function objects from 'fn' lists" do
      fn_list = list(var("fn"), list(var(:foo)), int(1))
      expect(described_class.new.eval(fn_list, env)).to eq fn(env, list(var(:foo)), list(int(1)))
    end

    it "returns quoted objects from quote" do
      quoted = list(var("quote"), list(int(1)))
      expect(described_class.new.eval(quoted, env)).to eq list(int(1))
    end

    it "applies builtin functions" do
      addition = list(var("+"), int(1), int(2))
      expect(described_class.new.eval(addition, env)).to eq int(3)
    end
  end
end
