module Rqlisp
  class Function < DataType
    attr_reader :env, :args, :code

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

    def call(arguments, env)
      apply(arguments.map { |arg| arg.eval(env) })
    end

    def apply(function, args)
      env = env_with_funcall_args(function, args)
      if function.code.is_a?(Method)
        function.code.call(env)
      else
        eval(function.code, env)
      end
    end

    private

    def env_with_funcall_args(function, args)
      env = Rqlisp::Env.new(parent: function.env)
      function.args.to_array.each_with_index do |arg_name, i|
        env.define(arg_name, args[i])
      end
      env
    end
  end
end
