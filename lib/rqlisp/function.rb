module Rqlisp
  class Function < DataType
    attr_reader :args, :code

    def initialize(env:, args:, code:)
      @env = env
      @args = args
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
        puts "method env: #{local_env}"
        code.call(local_env)
      else
        puts "apply env: #{local_env}"
        code.eval(local_env)
      end
    end

    def env_with_funcall_args(arg_values, env)
      new_local_env = Rqlisp::Env.new(parent: env)
      @args.to_array.each_with_index do |arg_name, i|
        new_local_env.define(arg_name, arg_values[i])
      end
      new_local_env
    end
  end
end
