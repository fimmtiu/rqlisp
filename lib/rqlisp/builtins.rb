module Rqlisp
  module Builtins
    extend DataHelpers

    BUILT_IN_FUNCTIONS = [
      {name: :addition, symbol: "+", args: %w(a b)},
      {name: :equal?, symbol: "=", args: %w(a b)},
      {name: :greater_than?, symbol: ">", args: %w(a b)},
      {name: :less_than?, symbol: "<", args: %w(a b)},
      {name: :print, symbol: "print", args: %w(expr)},
    ]

    BUILT_IN_MACROS = [
      {name: :set, symbol: "set", args: %w(variable value)},
    ]

    def self.add_to_environment(env)
      BUILT_IN_FUNCTIONS.each do |builtin|
        args = list(*builtin[:args].map { |name| var(name) })
        function = Rqlisp::Function.new(env: env, args: args, code: method(builtin[:name]))
        env.define(var(builtin[:symbol]), function)
      end

      BUILT_IN_MACROS.each do |builtin|
        args = list(*builtin[:args].map { |name| var(name) })
        macro = Rqlisp::Macro.new(env: env, args: args, code: method(builtin[:name]))
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
      value
    end
  end
end
