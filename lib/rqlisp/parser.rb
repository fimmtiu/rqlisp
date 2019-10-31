require "parslet"

module Rqlisp
  class Parser
    class Rules < Parslet::Parser
      rule(:space)      { match('\s').repeat(1) }
      rule(:space?)     { space.maybe }
      rule(:eol)        { match('[\r\n]').repeat(1) >> space? }

      rule(:comment)    { match(';') >> (eol.absent? >> any).repeat.as(:comment) }
      rule(:integer)    { (str('-').maybe >> match('[0-9]').repeat(1)).as(:integer) >> space? }
      rule(:string) {
        str('"') >> (
          (str('\\') >> any) |
          (str('"').absent? >> any)
        ).repeat.as(:string) >>
        str('"') >> space?
      }
      rule(:list)       { str('(') >> space? >> expression.repeat(0).as(:list) >> str(')') >> space? }
      # 'foo => (quote foo)
      rule(:expression) { list | string | integer | comment }
      root :expression
    end

    def initialize
      @rules = Rules.new
    end

    def parse(source)
      parse_tree = @rules.parse(source)
      convert_node_to_rqlisp_data(parse_tree)
    end

    private

    def convert_node_to_rqlisp_data(parse_tree)
      # require 'pry-byebug'; binding.pry
      type, value = parse_tree.to_a[0]
      case type
      # FIXME: This is a quick hack to fix the escaped double quote parsing. Should fix the rule instead.
      when :string then Rqlisp::String.new(value.to_str.gsub(/\\"/, '"'))
      when :integer then Rqlisp::Integer.new(value.to_int)
      when :list then Rqlisp::List.from_array(*value.map { |node| convert_node_to_rqlisp_data(node) })
      when :comment then nil
      end
    end
  end
end
