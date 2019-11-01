module Rqlisp
  class Function < DataType
    attr_reader :args, :code

    def initialize(env:, args:, code:)
      @env = env

      @args = args
      # FIXME: This arg counting is very inexact, and should be tightened up later.
      @rest_var = args.to_array.last if args.to_array.include?(var("&rest"))
      @arity = args.to_array.slice_before(var("&rest")).first&.count || 0

      if code.is_a?(Method)
        @code = code
      else
        @code = pair(var("do"), code)
      end
    end

    def ==(other)
      other.is_a?(Function) && args == other.args && code == other.code
    end

    def to_s
      body = if code.is_a?(Method)
               code
             else
               code.cdr.to_s[1..-2]   # ignore the "do" block
             end
      "(fn #{args} #{body})"
    end

    def call(arguments, caller_env)
      apply(arguments.map { |arg| arg.eval(caller_env) })
    end

    private

    def apply(arguments, env: @env)
      local_env = env_with_funcall_args(arguments, env)
      if code.is_a?(Method)
        code.call(local_env)
      else
        code.eval(local_env)
      end
    end

    # FIXME: This method has gotten a little long. Maybe pull the error handling out?
    def env_with_funcall_args(arg_values, env)
      new_local_env = Rqlisp::Env.new(parent: env)

      if arg_values.length < @arity
        raise "Not enough arguments to #{self}! Expected #{@arity}, got #{arg_values.length}"
      elsif !has_rest_args? && arg_values.length > @arity
        raise "Too many arguments to #{self}! Expected #{@arity}, got #{arg_values.length}"
      end

      @args.to_array.each_with_index do |arg_name, i|
        if arg_name == var("&rest")
          rest_values = list(*arg_values[i..-1])
          new_local_env.define(@rest_var, rest_values)
          break
        else
          new_local_env.define(arg_name, arg_values[i])
        end
      end

      new_local_env
    end

    def has_rest_args?
      args.to_array.any? { |arg| arg.value == :"&rest" }
    end
  end
end
