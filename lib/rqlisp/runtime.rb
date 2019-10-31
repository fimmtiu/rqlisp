module Rqlisp
  class Runtime
    include DataHelpers

    attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code)
      code = parser.parse(source_code)
      run_expr(list(list(var("fn"), list(), *code)))
    end

    def run_expr(expr)
      return expr if expr.literal?

      if expr.is_a?(Rqlisp::List)
        case expr[0]
        when var("fn")
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
