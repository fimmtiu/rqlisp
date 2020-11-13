require "parslet"
require "pry-byebug"

module Rqlisp
  class Parser
    class Rules < Parslet::Parser
      rule(:space)       { match('\s').repeat(1) }
      rule(:space?)      { space.maybe }
      rule(:eol)         { match('[\r\n]').repeat(1) >> space? }

      rule(:comment)     { str(";") >> (eol.absent? >> any).repeat.as(:comment) >> space? }
      rule(:integer)     { (str("-").maybe >> match("[0-9]").repeat(1)).as(:integer) >> space? }
      rule(:string) {
        str('"') >> (
          (str('\\') >> any) |
          (str('"').absent? >> any)
        ).repeat(0).as(:string) >>
        str('"') >> space?
      }
      rule(:list)        { str("(") >> space? >> expressions.as(:list) >> str(')') >> space? }
      rule(:variable)    { match("[a-zA-Z0-9?&<>=*+-]").repeat(1).as(:variable) >> space? }
      rule(:quote)       { str("'") >> expression.as(:quote) >> space? }
      rule(:quasiquote)  { str("`") >> expression.as(:quasiquote) >> space? }
      rule(:unquote_sp)  { str(",@") >> expression.as(:unquote_sp) >> space? }
      rule(:unquote)     { str(",") >> expression.as(:unquote) >> space? }
      rule(:expression)  { list | string | integer | comment | variable | quote | quasiquote | unquote | unquote_sp }
      rule(:expressions) { expression.repeat(0) }
      root :expressions
    end

    def initialize
      @rules = Rules.new
    end

    def parse(source)
      expressions = @rules.parse(source)
      recursively_convert_list(expressions)
    end

    private

    def convert_expr_to_rqlisp_data(parse_tree)
      type, value = parse_tree.to_a[0]
      case type
      when :comment  then nil
      when :integer  then Rqlisp::Integer.new(value.to_int)
      when :variable then Rqlisp::Variable.new(value.to_s)
      when :list     then recursively_convert_list(value)
      when :string
        if value == []
          Rqlisp::String.new("")
        else
          # FIXME: This is a quick hack to fix the escaped double quote parsing. Should fix the rule instead.
          Rqlisp::String.new(value.to_str.gsub(/\\"/, '"'))
        end
      when :quote, :quasiquote, :unquote
        Rqlisp::List.from_array(Rqlisp::Variable.new(type), convert_expr_to_rqlisp_data(value))
      when :unquote_sp
        expr = convert_expr_to_rqlisp_data(value)
        Rqlisp::List.from_array(Rqlisp::Variable.new(:"unquote-splicing"), expr)
      else
        binding.pry # rubocop:disable Lint/Debugger
        raise "wtf"
      end
    end

    def recursively_convert_list(expressions)
      if expressions.nil? || expressions == ""
        Rqlisp::List::EMPTY
      else
        rqlisp_expressions = expressions.map { |node| convert_expr_to_rqlisp_data(node) }.compact
        Rqlisp::List.from_array(*rqlisp_expressions)
      end
    end
  end
end
