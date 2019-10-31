module Rqlisp
  class String < DataType
    def initialize(ruby_str)
      @value = ruby_str
    end

    def literal?
      true
    end
  end
end
