module Rqlisp
  class Runtime
   attr_reader :code, :parser

    def initialize
      @parser = Rqlisp::Parser.new
    end

    def run(source_code)
      @code = parser.parse(source_code)
      # FIXME
    end
  end
end
