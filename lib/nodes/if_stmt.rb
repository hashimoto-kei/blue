# frozen_string_literal: true

module Node
  class IfStmt
    attr_reader :condition, :then_body, :else_body

    def initialize(condition, then_body, else_body)
      @condition = condition
      @then_body = then_body
      @else_body = else_body
    end

    def accept(visitor)
      visitor.visit_if_stmt_node(self)
    end
  end
end
