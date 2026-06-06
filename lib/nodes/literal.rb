# frozen_string_literal: true

module Node
  class Literal
    attr_reader :literal

    def initialize(literal)
      @literal = literal
    end

    def accept(visitor)
      visitor.visit_literal_node(self)
    end
  end
end
