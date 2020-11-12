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

  describe ".less_than?" do
    it "returns true when a is < b" do
      expect(Rqlisp::Runtime.new.run("(< 1 2)")).to eq Rqlisp::TRUE
    end

    it "returns false when a is >= b" do
      expect(Rqlisp::Runtime.new.run("(< 2 2)")).to eq Rqlisp::FALSE
    end
  end

  describe ".greater_than?" do
    it "returns true when a is > b" do
      expect(Rqlisp::Runtime.new.run("(> 2 1)")).to eq Rqlisp::TRUE
    end

    it "returns false when a is <= b" do
      expect(Rqlisp::Runtime.new.run("(> 2 2)")).to eq Rqlisp::FALSE
    end
  end

  describe ".equal?" do
    it "returns true when a and b are the same" do
      expect(Rqlisp::Runtime.new.run("(= 2 2)")).to eq Rqlisp::TRUE
      expect(Rqlisp::Runtime.new.run('(= "foo" "foo")')).to eq Rqlisp::TRUE
    end

    it "returns false when a and b are different" do
      expect(Rqlisp::Runtime.new.run("(= 1 2)")).to eq Rqlisp::FALSE
      expect(Rqlisp::Runtime.new.run('(= "foo" "bar")')).to eq Rqlisp::FALSE
    end
  end

  describe ".set" do
    it "establishes a new variable in the current env if it doesn't exist" do
      expect(Rqlisp::Runtime.new.run("(set a 1) a")).to eq int(1)
    end

    it "changes the value of an existing variable in the current env" do
      expect(Rqlisp::Runtime.new.run("((fn (a) (set a 2) a) 1)")).to eq int(2)
    end
  end

  describe ".type_of" do
    it "returns type names for objects" do
      expect(Rqlisp::Runtime.new.run("(type-of 1)")).to eq str("integer")
      expect(Rqlisp::Runtime.new.run('(type-of "woo")')).to eq str("string")
      expect(Rqlisp::Runtime.new.run("(type-of (fn () 1))")).to eq str("function")
      expect(Rqlisp::Runtime.new.run("(type-of nil)")).to eq str("nil")
    end
  end

  describe ".car" do
    it "returns the car of a list" do
      expect(Rqlisp::Runtime.new.run("(car '(1 2))")).to eq int(1)
    end

    it "returns nil for an empty list" do
      expect(Rqlisp::Runtime.new.run("(car '())")).to eq Rqlisp::NIL
    end
  end

  describe ".cdr" do
    it "returns the cdr of a list" do
      expect(Rqlisp::Runtime.new.run("(cdr '(1 2))")).to eq list(int(2))
    end

    it "returns nil for an empty list" do
      expect(Rqlisp::Runtime.new.run("(cdr '())")).to eq Rqlisp::NIL
    end
  end

  describe ".nil?" do
    it "returns true if the value is nil" do
      expect(Rqlisp::Runtime.new.run("(nil? nil)")).to eq Rqlisp::TRUE
    end

    it "returns false if the value is not nil" do
      expect(Rqlisp::Runtime.new.run("(nil? 1)")).to eq Rqlisp::FALSE
    end
  end

  describe ".empty?" do
    it "returns true if the value is an empty list" do
      expect(Rqlisp::Runtime.new.run("(empty? '())")).to eq Rqlisp::TRUE
    end

    it "returns false if the value is not an empty list" do
      expect(Rqlisp::Runtime.new.run("(empty? '(1))")).to eq Rqlisp::FALSE
      expect(Rqlisp::Runtime.new.run("(empty? 2)")).to eq Rqlisp::FALSE
    end
  end

  describe ".list" do
    it "returns a list of its arguments" do
      expect(Rqlisp::Runtime.new.run("(list)")).to eq Rqlisp::List::EMPTY
      expect(Rqlisp::Runtime.new.run("(list 1 2 3)")).to eq list(int(1), int(2), int(3))
    end
  end

  describe ".append" do
    it "returns a concatenated list of its argument lists" do
      expect(Rqlisp::Runtime.new.run("(append)")).to eq Rqlisp::List::EMPTY
      expect(Rqlisp::Runtime.new.run("(append '(1 2))")).to eq list(int(1), int(2))
      expect(Rqlisp::Runtime.new.run("(append '(1 2) '(3))")).to eq list(int(1), int(2), int(3))
    end
  end
end
