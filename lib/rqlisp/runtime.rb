module Rqlisp
  class Runtime
    include DataHelpers

    attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code)
      code = parser.parse(source_code)
      top_level_env = Env.new(nil)
      eval(list(list(var("fn"), list(), *code)), top_level_env)
    end

    def eval(expr, env)
      return expr if expr.literal?

      if expr.is_a?(Rqlisp::List)
        case expr[0]
        when var("fn")
          raise "'fn' requires an argument list!" if !expr[1].is_a?(List)
          fn(expr[1], expr.cdr.cdr)
        when var("quote")
          raise "'quote' takes only one argument!" if expr.cdr.length != 1
          expr.cdr.car
        else
          binding.pry
          raise "wtf"
        end
      else
        binding.pry
        raise "wtf"
      end
    end
  end
end
