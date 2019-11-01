module Rqlisp
  module Builtins
    extend DataHelpers

    BUILT_IN_FUNCTIONS = [
      {name: :addition, symbol: "+", args: list(var("a"), var("b"))},
      {name: :equal?, symbol: "=", args: list(var("a"), var("b"))},
      {name: :greater_than?, symbol: ">", args: list(var("a"), var("b"))},
      {name: :less_than?, symbol: "<", args: list(var("a"), var("b"))},
      {name: :print, symbol: "print", args: list(var("expr"))},
    ]

    BUILT_IN_MACROS = [
      # {name: :def, symbol: "def", args: list(var("args"), var("code"))},
      {name: :set, symbol: "set", args: list(var("variable"), var("value"))},
    ]

    def self.add_to_environment(env)
      BUILT_IN_FUNCTIONS.each do |builtin|
        function = Rqlisp::Function.new(env: env, args: builtin[:args], code: method(builtin[:name]))
        env.define(var(builtin[:symbol]), function)
      end

      BUILT_IN_MACROS.each do |builtin|
        macro = Rqlisp::Macro.new(env: env, args: builtin[:args], code: method(builtin[:name]))
        env.define(var(builtin[:symbol]), macro)
      end
    end

    def self.addition(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      int(a.value + b.value)
    end

    def self.equal?(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      a.value == b.value ? TRUE : FALSE
    end

    def self.greater_than?(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      a.value > b.value ? TRUE : FALSE
    end

    def self.less_than?(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      a.value < b.value ? TRUE : FALSE
    end

    def self.print(env)
      expr = env.lookup(var(:expr))
      puts expr.to_s
      NIL
    end

    def self.set(env)
      variable = env.lookup(var(:variable))
      value_expr = env.lookup(var(:value))
      value = value_expr.eval(env)
      env.parent_env.set(variable, value)
      puts "set env: #{env}"
      puts "set parent env: #{env.parent_env}"
      value
    end
  end
end
