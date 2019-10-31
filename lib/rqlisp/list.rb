module Rqlisp
  class List < DataType
    class EmptyList < List
      def initialize
      end

      def ==(other)
        self.object_id == other.object_id
      end
    end

    EMPTY = EmptyList.new

    attr_reader :car, :cdr

    def self.from_array(*items)
      new_list = EMPTY
      while !items.empty?
        new_list = Rqlisp::List.new(items.pop, new_list)
      end
      new_list
    end

    def initialize(car, cdr = EMPTY)
      @car = car
      @cdr = cdr
    end

    def ==(other)
      other.is_a?(List) && car == other.car && cdr == other.cdr
    end
  end
end
