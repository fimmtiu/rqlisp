module Rqlisp
  module Builtins
    extend DataHelpers

    BUILT_IN_FUNCTIONS = [
      { name: :addition, symbol: "+", args: %w(a b) },
      { name: :append, symbol: "append", args: %w(&rest lists) },
      { name: :car, symbol: "car", args: %w(lst) },
      { name: :cdr, symbol: "cdr", args: %w(lst) },
      { name: :debug, symbol: "debug", args: %w() },
      { name: :empty?, symbol: "empty?", args: %w(expr) },
      { name: :equal?, symbol: "=", args: %w(a b) },
      { name: :greater_than?, symbol: ">", args: %w(a b) },
      { name: :less_than?, symbol: "<", args: %w(a b) },
      { name: :list_builtin, symbol: "list", args: %w(&rest exprs) },
      { name: :nil?, symbol: "nil?", args: %w(expr) },
      { name: :print, symbol: "print", args: %w(expr) },
      { name: :type_of, symbol: "type-of", args: %w(expr) },
      { name: :unquote, symbol: "unquote", args: %w(expr) },
      { name: :unquote_splicing, symbol: "unquote-splicing", args: %w(expr) },
    ]

    BUILT_IN_MACROS = [
      { name: :set, symbol: "set", args: %w(variable value) },
      { name: :quasiquote, symbol: "quasiquote", args: %w(&rest exprs) },
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

    def self.debug(env)
      binding.pry # rubocop:disable Lint/Debugger
      NIL
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

    def self.quasiquote(env)
      exprs = env.lookup(var(:exprs))
      expanded = _recursive_quasiquoter(exprs, env.parent_env)
      list(var("quote"), expanded)
    end

    def self._recursive_quasiquoter(expr, env)
      return expr if !expr.is_a?(List) || expr == List::EMPTY

      new_list = []
      until expr == List::EMPTY
        if expr.car.is_a?(List)
          case expr.car.car
          when var("quasiquote")
            new_list << expr.car.eval(env)
          when var("unquote")
            new_list << expr.car.cdr.car.eval(env)
          when var("unquote-splicing")
            new_list.concat(expr.car.cdr.car.eval(env).to_array) if expr.car.cdr.car != List::EMPTY
          else
            new_list << _recursive_quasiquoter(expr.car, env)
          end
        else
          new_list << _recursive_quasiquoter(expr.car, env)
        end
        puts "new_list: [#{new_list.map(&:to_s).join(" ")}]"
        expr = expr.cdr
      end

      Rqlisp::List.from_array(*new_list)
    end

    def self.unquote(_env)
      raise "unquote is only valid inside a quasiquote expression"
    end

    def self.unquote_splicing(_env)
      raise "unquote-splicing is only valid inside a quasiquote expression"
    end

    def self.type_of(env)
      expr = env.lookup(var(:expr))
      str(expr.type)
    end
  end
end
