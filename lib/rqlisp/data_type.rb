module Rqlisp
  class DataType
    include DataHelpers

    # FIXME: Get rid of almost all of this. There are lots of types that don't use 'value'.
    attr_reader :value

    def ==(other)
      other.is_a?(self.class) && value == other.value
    end

    def to_s
      value.to_s
    end

    def eval(_env)
      self
    end

    def type
      self.class.name.sub("Rqlisp::", "").downcase
    end
  end
end
