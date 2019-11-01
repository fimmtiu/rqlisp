module Rqlisp
  class Runtime
    include DataHelpers

    attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code)
      code = parser.parse(source_code)
      top_level_env = Env.new(parent: nil)
      Rqlisp::Builtins.add_to_environment(top_level_env)
      eval(list(list(var("fn"), list(), *code)), top_level_env)
    end

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
        else
          function = eval(expr[0], env)
          binding.pry
          apply(function, expr.cdr)
        end
      else
        raise "wtf"
      end
    end

    private

    def env_for_funcall(function, args)
      env = Rqlisp::Env.new(parent: function.env)
      function.args.to_array.each_with_index do |arg_name, i|
        env.define(arg_name, args[i])
      end
      env
    end

    def apply(function, args)
      env = env_for_funcall(function, args)
      if function.code.is_a?(Method)
        function.code.call(env)
      else
        eval(function.code, env)
      end
    end
  end
end
