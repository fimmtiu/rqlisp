module Rqlisp
  module Builtins
    extend DataHelpers

    def self.add_to_environment(env)
      [
        {name: :addition, symbol: "+", args: list(var("a"), var("b"))},
      ].each do |builtin|
        function = Rqlisp::Function.new(env: builtin[:env], args: builtin[:args], code: method(:addition))
        env.define(var(builtin[:symbol]), function)
      end
    end

    def self.addition(env)
      a = env.lookup(var(:a))
      b = env.lookup(var(:b))
      int(a.value + b.value)
    end
  end
end
