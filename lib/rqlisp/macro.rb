module Rqlisp
  class Macro < Function
    def to_s
      super.sub("fn", "macro")
    end

    def call(arguments, caller_env)
      apply(arguments, env: caller_env)
    end
  end
end
