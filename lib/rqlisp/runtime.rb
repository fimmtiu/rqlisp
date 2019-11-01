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
      eval(top_level_expr, top_level_env)
    end

    private

    def eval(expr, env)
      case expr
      when Rqlisp::String, Rqlisp::Integer, Rqlisp::Function, Method
        expr

      when Rqlisp::Variable
        env.lookup(expr)

      when Rqlisp::List
        case expr[0]
        when var("fn")
          raise "'fn' requires an argument list!" if !expr[1].is_a?(List)
          Rqlisp::Function.new(env: env, args: expr[1], code: expr.cdr.cdr)
        when var("quote")
          raise "'quote' takes only one argument!" if expr.cdr.length != 1
          expr.cdr.car
        when var("do")
          last_value = List::EMPTY
          expr.cdr.to_array.each do |expr|
            last_value = eval(expr, env)
          end
          last_value
        else
          function = eval(expr[0], env)
          arguments = expr.cdr.to_array.map { |arg| eval(arg, env) }
          apply(function, arguments)
        end
      else
        binding.pry
        raise "wtf"
      end
    end

    def top_level_env
      Env.new(parent: nil).tap do |env|
        Rqlisp::Builtins.add_to_environment(env)
      end
    end

    def env_with_funcall_args(function, args)
      env = Rqlisp::Env.new(parent: function.env)
      function.args.to_array.each_with_index do |arg_name, i|
        env.define(arg_name, args[i])
      end
      env
    end

    def apply(function, args)
      env = env_with_funcall_args(function, args)
      if function.code.is_a?(Method)
        function.code.call(env)
      else
        eval(function.code, env)
      end
    end
  end
end
