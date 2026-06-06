# frozen_string_literal: true

module Node
  class Unary
    attr_reader :op, :rhs

    def initialize(op, rhs)
      @op = op
      @rhs = rhs
    end

    def accept(visitor)
      visitor.visit_unary_node(self)
    end
  end
end
