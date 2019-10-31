require "parslet"

module Rqlisp
  class Parser
    class Rules < Parslet::Parser
      rule(:space)       { match('\s').repeat(1) }
      rule(:space?)      { space.maybe }
      rule(:eol)         { match('[\r\n]').repeat(1) >> space? }

      rule(:comment)     { str(';') >> (eol.absent? >> any).repeat.as(:comment) >> space? }
      rule(:integer)     { (str('-').maybe >> match('[0-9]').repeat(1)).as(:integer) >> space? }
      rule(:string) {
        str('"') >> (
          (str('\\') >> any) |
          (str('"').absent? >> any)
        ).repeat.as(:string) >>
        str('"') >> space?
      }
      rule(:list)        { str('(') >> space? >> expression.repeat(0).as(:list) >> str(')') >> space? }
      rule(:variable)    { match('[a-zA-Z0-9*-+]').repeat(1).as(:variable) >> space? }
      rule(:quote)       { str("'") >> expression.as(:quote) >> space? }
      rule(:expression)  { list | string | integer | comment | variable | quote }
      rule(:expressions) { expression.repeat(1) }
      root :expressions
    end

    def initialize
      @rules = Rules.new
    end

    def parse(source)
      raw_expressions = @rules.parse(source)
      expressions = raw_expressions.map { |expr| convert_expr_to_rqlisp_data(expr) }.compact
      Rqlisp::List.from_array(*expressions)
    end

    private

    def convert_expr_to_rqlisp_data(parse_tree)
      # require 'pry-byebug'; binding.pry
      type, value = parse_tree.to_a[0]
      case type
      # FIXME: This is a quick hack to fix the escaped double quote parsing. Should fix the rule instead.
      when :string then Rqlisp::String.new(value.to_str.gsub(/\\"/, '"'))
      when :integer then Rqlisp::Integer.new(value.to_int)
      when :variable then Rqlisp::Variable.new(value.to_s)
      when :list then Rqlisp::List.from_array(*value.map { |node| convert_expr_to_rqlisp_data(node) }.compact)
      when :quote then # FIXME
      when :comment then nil
      else
        require 'pry-byebug'; binding.pry
        puts "wtf"
      end
    end
  end
end
