module Rqlisp
  class List < DataType
    class EmptyList < List
      def initialize
      end

      def ==(other)
        object_id == other.object_id
      end

      def to_array
        []
      end
    end

    EMPTY = EmptyList.new

    attr_reader :car, :cdr

    def self.from_array(*items)
      new_list = EMPTY
      while !items.empty?
        new_list = new(items.pop, new_list)
      end
      new_list
    end

    def initialize(car, cdr = EMPTY)
      @car = car
      raise "Dotted lists are a pain in the ass!" if !cdr.is_a?(List)
      @cdr = cdr
    end

    def [](index)
      to_array[index]
    end

    def length
      to_array.length
    end

    # We don't want to override to_a because we get fun problems with Ruby doing implicit conversions on it.
    def to_array
      [car].concat(cdr.to_array)
    end

    def ==(other)
      other.is_a?(List) && car == other.car && cdr == other.cdr
    end

    def to_s
      "(" + to_array.join(" ") + ")"
    end
  end
end
