require "rqlisp/data_helpers"
require "rqlisp/data_type"
require "rqlisp/env"
require "rqlisp/function"
require "rqlisp/integer"
require "rqlisp/list"
require "rqlisp/parser"
require "rqlisp/string"
require "rqlisp/variable"
require "rqlisp/version"
require "rqlisp/builtins"
require "rqlisp/runtime"

module Rqlisp
  class Error < StandardError; end

  def self.run(code)
    Rqlisp::Runtime.new.run(code)
  end
end
