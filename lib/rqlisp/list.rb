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

    attr_accessor :car
    attr_reader :cdr

    def self.from_array(*items)
      new_list = EMPTY
      while !items.empty?
        new_list = new(items.pop, new_list)
      end
      new_list
    end

    def initialize(car, cdr = EMPTY)
      self.car = car
      self.cdr = cdr
    end

    def cdr=(new_cdr)
      raise "Dotted lists are a pain in the ass!" if !new_cdr.is_a?(List)
      @cdr = new_cdr
    end

    def [](index)
      to_array[index]
    end

    def []=(index, new_value)
      raise "index #{index} out of range [0..#{length})" if index > length - 1 || index < 0
      list = self
      index.times { list = list.cdr }
      list.car = new_value
    end

    def length
      to_array.length
    end

    # We don't want to override to_a because we get fun problems with Ruby doing implicit conversions on it.
    def to_array
      [car].concat(cdr.to_array)
    end

    def each(&block)
      to_array.each(&block)
    end

    def ==(other)
      other.is_a?(List) && car == other.car && cdr == other.cdr
    end

    def to_s
      "(" + to_array.join(" ") + ")"
    end

    # FIXME: Break up this method.
    def eval(env)
      case car
      when var("fn")
        raise "'fn' requires an argument list!" if !self[1].is_a?(List)
        Rqlisp::Function.new(env: env, args: self[1], code: cdr.cdr)
      when var("defmacro")
        raise "'defmacro' requires a name and argument list!" if !self[2].is_a?(List)
        macro = Rqlisp::Macro.new(env: env, args: self[2], code: cdr.cdr.cdr)
        env.set(self[1], macro)
      when var("quote")
        raise "'quote' takes only one argument!" if cdr.length != 1
        cdr.car
      when var("if")
        # FIXME needs error handling
        condition = self[1].eval(env)
        if condition != FALSE && condition != NIL
          self[2].eval(env)
        elsif length > 3
          self[3].eval(env)
        else
          NIL
        end
      when var("do")
        last_value = List::EMPTY
        cdr.to_array.each do |inner_expr|
          last_value = inner_expr.eval(env)
        end
        last_value
      else
        function = car.eval(env)
        function.call(cdr.to_array, env)
      end
    end
  end
end
