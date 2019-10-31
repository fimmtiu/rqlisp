module Rqlisp
  class Variable < DataType
    def initialize(ruby_str)
      @value = ruby_str.to_sym
    end
  end
end
