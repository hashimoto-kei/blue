# frozen_string_literal: true

module Node
  class ExprStmt
    attr_reader :expr

    def initialize(expr)
      @expr = expr
    end

    def accept(visitor)
      visitor.visit_expr_stmt_node(self)
    end
  end
end
