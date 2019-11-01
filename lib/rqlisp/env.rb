module Rqlisp
  class Env < DataType
    attr_reader :vars, :parent_env

    def initialize(parent:, vars: {})
      @parent_env = parent
      @vars = vars
    end

    def lookup(var)
      if env = find_env_containing_var(var)
        env.vars[var.value]
      else
        raise "Unknown variable: #{var.value}\nCurrent env: #{self}"
      end
    end

    def set(var, new_value)
      if env = find_env_containing_var(var)
        env.define(var, new_value)
      else
        define(var, new_value)
      end
    end

    def define(var, new_value)
      @vars[var.value] = new_value
    end

    def find_env_containing_var(var)
      if @vars.key?(var.value)
        return self
      elsif @parent_env
        @parent_env.find_env_containing_var(var)
      else
        nil
      end
    end

    def to_s
      repr = "(env"
      repr += vars.map do |name, value|
        " #{name} => #{value}"
      end.join(",")
      repr + ")"
    end
  end
end
