module Rqlisp
  class Variable < DataType
    def initialize(ruby_str)
      @value = ruby_str.to_sym
    end

    def eval(env)
      case value
      when :true then Rqlisp::TRUE
      when :false then Rqlisp::FALSE
      when :nil then Rqlisp::NIL
      else env.lookup(self)
      end
    end
  end
end
