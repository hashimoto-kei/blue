# frozen_string_literal: true

module Node
  class WhileStmt
    attr_reader :condition, :body

    def initialize(condition, body)
      @condition = condition
      @body = body
    end

    def accept(visitor)
      visitor.visit_while_stmt_node(self)
    end
  end
end
