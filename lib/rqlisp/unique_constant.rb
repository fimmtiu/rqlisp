module Rqlisp
  class UniqueConstant < DataType
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ==(other)
      other.is_a?(UniqueConstant) && name == other.name
    end

    def to_s
      name.to_s
    end

    def type
      name
    end
  end
end
