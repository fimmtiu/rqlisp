module Rqlisp
  class Function < DataType
    include DataHelpers

    attr_reader :env, :args, :code

    def initialize(env:, args:, code:)
      @env = env
      @args = args
      if code.is_a?(Method)
        @code = code
      else
        @code = pair(var("do"), code)
      end
    end

    def ==(other)
      other.is_a?(Function) && args == other.args && code == other.code
    end

    def to_s
      body = if code.is_a?(Method)
               code
             else
               code.cdr.to_s[1..-2]   # ignore the "do" block
             end
      "(fn #{args} #{body})"
    end
  end
end
