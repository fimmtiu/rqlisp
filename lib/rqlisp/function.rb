module Rqlisp
  class Function < DataType
    attr_reader :env, :args, :code

    def initialize(env:, args:, code:)
      @env = env
      @args = args
      @code = code
    end

    def ==(other)
      other.is_a?(Function) && args == other.args && code == other.code
    end
  end
end
