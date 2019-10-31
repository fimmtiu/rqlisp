module DataHelpers
  def int(ruby_int)
    Rqlisp::Integer.new(ruby_int)
  end

  def str(ruby_str)
    Rqlisp::String.new(ruby_str)
  end
end
