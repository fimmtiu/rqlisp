require "parslet"

module Rqlisp
  class Parser
    class Rules < Parslet::Parser
      rule(:space)      { match('\s').repeat(1) }
      rule(:space?)     { space.maybe }

      rule(:integer)    { (str('-').maybe >> match('[0-9]').repeat(1)).as(:integer) >> space? }
      rule(:string) {
        str('"') >> (
          (str('\\') >> any) |
          (str('"').absent? >> any)
        ).repeat.as(:string) >>
        str('"') >> space?
      }
      rule(:list)       { str('(') >> space? >> expression.repeat(1) >> str(')') >> space? }
      # 'foo => (quote foo)
      # EOL comments - https://github.com/kschiess/parslet/blob/master/example/string_parser.rb
      rule(:expression) { list | string | integer }
      root :expression
    end

    def initialize
      @rules = Rules.new
    end

    def parse(source)
      parse_tree = @rules.parse(source)
      # require "pry-byebug"; binding.pry

      convert_node_to_rqlisp_data(parse_tree)
    end

    private

    def convert_node_to_rqlisp_data(parse_tree)
      type, value = parse_tree.to_a[0]
      case type
      when :string then Rqlisp::String.new(value.to_str.gsub(/\\"/, '"'))
      when :integer then Rqlisp::Integer.new(value.to_int)
      end
    end
  end
end
