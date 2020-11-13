require "spec_helper"

RSpec.describe "derived expressions" do
  let(:runtime) { Rqlisp::Runtime.new }

  describe "defn" do
    it "defines a function" do
      expect(runtime.run("(defn return-31337 () 31337) (return-31337)")).to eq int(31337)
    end

    it "defines a function with an argument" do
      expect(runtime.run("(defn identity (foo) foo) (identity 31337)")).to eq int(31337)
    end
  end
end
