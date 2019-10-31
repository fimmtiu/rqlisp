module Rqlisp
  class Integer < DataType
    def initialize(ruby_int)
      @value = ruby_int
    end

    def literal?
      true
    end
  end
end
