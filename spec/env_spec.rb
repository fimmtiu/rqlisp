require "spec_helper"

RSpec.describe Rqlisp::Env do
  let(:top_level_env) { described_class.new(nil, foo: int(1)) }
  let(:child_env) { described_class.new(top_level_env, bar: int(2)) }

  describe "#lookup" do
    it "looks up variables recursively" do
      expect(child_env.lookup(var(:foo))).to eq int(1)
      expect(child_env.lookup(var(:bar))).to eq int(2)
      expect { child_env.lookup(var(:baz)) }.to raise_error(/Unknown variable/)
    end
  end

  describe "#set" do
    it "modifies the environment containing the variable, if it exists" do
      child_env.set(var(:foo), int(3))
      expect(child_env.lookup(var(:foo))).to eq int(3)
      expect(top_level_env.lookup(var(:foo))).to eq int(3)
    end

    it "creates the variable in the current environment if it doesn't exist" do
      child_env.set(var(:baz), int(3))
      expect(child_env.lookup(var(:baz))).to eq int(3)
      expect { top_level_env.lookup(var(:baz)) }.to raise_error(/Unknown variable/)
    end
  end

  describe "#define" do
    it "only modifies the current env" do
      child_env.define(var(:foo), int(3))
      expect(child_env.lookup(var(:foo))).to eq int(3)
      expect(top_level_env.lookup(var(:foo))).to eq int(1)
    end
  end
end
