# frozen_string_literal: true

module Node
  class Binary
    attr_reader :op, :lhs, :rhs

    def initialize(op, lhs, rhs)
      @op = op
      @lhs = lhs
      @rhs = rhs
    end

    def accept(visitor)
      visitor.visit_binary_node(self)
    end
  end
end
