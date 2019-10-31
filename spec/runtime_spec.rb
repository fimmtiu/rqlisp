require "spec_helper"

RSpec.describe Rqlisp::Runtime do
  describe "#run_expr" do
    it "creates function objects from 'fn' lists" do
      fn_list = list(var("fn"), list(var(:foo)), int(1))
      expect(described_class.new.run_expr(fn_list)).to eq fn(list(var(:foo)), list(int(1)))
    end

    it "returns quoted objects from quote" do
      quoted = list(var("quote"), list(int(1)))
      expect(described_class.new.run_expr(quoted)).to eq list(int(1))
    end
  end
end
