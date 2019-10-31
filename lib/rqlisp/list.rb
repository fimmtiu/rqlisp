module Rqlisp
  class List < DataType
    attr_reader :car, :cdr

    def initialize(car, cdr = nil)
      @car = car
      @cdr = cdr
    end

    def ==(other)
      car == other.car && cdr == other.cdr
    end
  end
end
