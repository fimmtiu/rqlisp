module Rqlisp
  class Runtime
    include DataHelpers

    attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code)
      code = parser.parse(source_code)
      top_level_expr = list(list(var("fn"), list()))
      top_level_expr.car.cdr.cdr = code
      top_level_expr.eval(top_level_env)
    end

    private

    def eval(expr, env)
      expr.eval(env)
    end

    def top_level_env
      Env.new(parent: nil).tap do |env|
        Rqlisp::Builtins.add_to_environment(env)
      end
    end
  end
end
