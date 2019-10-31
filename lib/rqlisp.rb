require "rqlisp/data_type"
require "rqlisp/integer"
require "rqlisp/list"
require "rqlisp/parser"
require "rqlisp/runtime"
require "rqlisp/string"
require "rqlisp/variable"
require "rqlisp/version"

module Rqlisp
  class Error < StandardError; end

  def self.run(code)
    Rqlisp::Runtime.new.run(code)
  end

  def self.[](list)
    FIXME
  end
end
