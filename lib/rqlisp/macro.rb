module Rqlisp
  class Macro < Function
    def to_s
      super.sub("fn", "defmacro")
    end

    def call(arguments, caller_env)
      code = apply(arguments, env: caller_env)
      code.eval(caller_env)
    end
  end
end
