module Rqlisp
  class Runtime
    include DataHelpers

    DERIVED_EXPRESSIONS = <<~CODE
      (defmacro defn (name args &rest code)
        `(set ,name (fn ,args ,@code)))
    CODE

    attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code, bindings: {})
      code = parser.parse(source_code)
      top_level_expr = list(list(var("fn"), list()))
      top_level_expr.car.cdr.cdr = code
      top_level_expr.eval(top_level_env(bindings))
    end

    private

    def eval(expr, env)
      expr.eval(env)
    end

    def top_level_env(bindings)
      Env.new(parent: nil).tap do |env|
        Rqlisp::Builtins.add_to_environment(env)
        derived_exprs = parser.parse(DERIVED_EXPRESSIONS)
        derived_exprs.to_array.map { |expr| expr.eval(env) }
        bindings.each { |sym, value| env.set(var(sym), value) }
      end
    end
  end
end
