module Rqlisp
  class DataType
    attr_reader :value

    def ==(other)
      other.is_a?(self.class) && value == other.value
    end

    def literal?
      false
    end

    def to_s
      value.to_s
    end
  end
end
