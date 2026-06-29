# frozen_string_literal: true

module Node
  class Logical
    attr_reader :op, :lhs, :rhs

    def initialize(op, lhs, rhs)
      @op = op
      @lhs = lhs
      @rhs = rhs
    end

    def accept(visitor)
      visitor.visit_logical_node(self)
    end
  end
end
