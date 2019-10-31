module DataHelpers
  def int(ruby_int)
    Rqlisp::Integer.new(ruby_int)
  end

  def str(ruby_str)
    Rqlisp::String.new(ruby_str)
  end

  def pair(car, cdr = Rqlisp::List::EMPTY)
    Rqlisp::List.new(car, cdr)
  end

  def list(*items)
    Rqlisp::List.from_array(*items)
  end

  def var(ruby_str)
    Rqlisp::Variable.new(ruby_str)
  end

  def fn(args, code)
    Rqlisp::Function.new(args, code)
  end
end