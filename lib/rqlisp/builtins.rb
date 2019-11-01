module Rqlisp
  module Builtins
    extend DataHelpers

    BUILT_IN_FUNCTIONS = [
      {name: :addition, symbol: "+", args: %w(a b)},
      {name: :append, symbol: "append", args: %w(&rest lists)},
      {name: :car, symbol: "car", args: %w(lst)},
      {name: :cdr, symbol: "cdr", args: %w(lst)},
      {name: :empty?, symbol: "empty?", args: %w(expr)},
      {name: :equal?, symbol: "=", args: %w(a b)},
      {name: :greater_than?, symbol: ">", args: %w(a b)},
      {name: :less_than?, symbol: "<", args: %w(a b)},
      {name: :list_builtin, symbol: "list", args: %w(&rest exprs)},
      {name: :nil?, symbol: "nil?", args: %w(expr)},
      {name: :print, symbol: "print", args: %w(expr)},
      {name: :type_of, symbol: "type-of", args: %w(expr)},
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

    # FIXME: Error checking; all args must be lists.
    def self.append(env)
      lists = env.lookup(var(:lists))
      list_arr = lists.to_array.map(&:to_array)
      list(*list_arr.flatten)
    end

    def self.car(env)
      env.lookup(var(:lst)).car || NIL
    end

    def self.cdr(env)
      env.lookup(var(:lst)).cdr || NIL
    end

    def self.empty?(env)
      expr = env.lookup(var(:expr))
      expr == List::EMPTY ? TRUE : FALSE
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

    def self.list_builtin(env)
      exprs = env.lookup(var(:exprs))
      exprs
    end

    def self.nil?(env)
      expr = env.lookup(var(:expr))
      expr == NIL ? TRUE : FALSE
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

    def self.type_of(env)
      expr = env.lookup(var(:expr))
      str(expr.type)
    end
  end
end
