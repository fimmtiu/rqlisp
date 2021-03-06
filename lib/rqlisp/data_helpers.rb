module Rqlisp
  module DataHelpers
    def int(ruby_int)
      Rqlisp::Integer.new(ruby_int)
    end

    def str(ruby_str)
      Rqlisp::String.new(ruby_str)
    end

    def pair(car, cdr = Rqlisp::List::EMPTY)
      Rqlisp::List.new(car, cdr)
    end

    def list(*items)
      Rqlisp::List.from_array(*items)
    end

    def var(ruby_str)
      Rqlisp::Variable.new(ruby_str)
    end

    def fn(env, args, code)
      Rqlisp::Function.new(env: env, args: args, code: code)
    end
  end
end
