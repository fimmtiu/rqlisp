module Rqlisp
  class DataType
    attr_reader :value

    def ==(other)
      value == other.value
    end
  end
end
