module Rqlisp
  class Function < DataType
    attr_reader :args, :code

    def initialize(args, code)
      @args = args
      @code = code
    end

    def ==(other)
      other.is_a?(Function) && args == other.args && code == other.code
    end

    def literal?
      true
    end
  end
end
