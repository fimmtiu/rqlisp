module Rqlisp
  module Builtins
    extend DataHelpers

    BUILT_IN_FUNCTIONS = [
      {name: :addition, symbol: "+", args: list(var("a"), var("b"))},
      {name: :print, symbol: "print", args: list(var("expr"))},
    ]

    def self.add_to_environment(env)
      BUILT_IN_FUNCTIONS.each do |builtin|
        function = Rqlisp::Function.new(env: builtin[:env], args: builtin[:args], code: method(builtin[:name]))
        env.define(var(builtin[:symbol]), function)
      end
    end

    def self.addition(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      int(a.value + b.value)
    end

    def self.print(env)
      expr = env.lookup(var(:expr))
      puts expr.to_s
      NIL
    end
  end
end
