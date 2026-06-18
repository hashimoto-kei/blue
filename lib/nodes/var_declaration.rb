# frozen_string_literal: true

module Node
  class VarDeclaration
    attr_reader :lhs, :rhs

    def initialize(lhs, rhs)
      @lhs = lhs
      @rhs = rhs
    end

    def accept(visitor)
      visitor.visit_var_declaration_node(self)
    end
  end
end
