# frozen_string_literal: true

module Node
  class Assign
    attr_reader :lhs, :rhs

    def initialize(lhs, rhs)
      @lhs = lhs
      @rhs = rhs
    end

    def accept(visitor)
      visitor.visit_assign_node(self)
    end
  end
end
