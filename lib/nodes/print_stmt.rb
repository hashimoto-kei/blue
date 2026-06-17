# frozen_string_literal: true

module Node
  class PrintStmt
    attr_reader :expr

    def initialize(expr)
      @expr = expr
    end

    def accept(visitor)
      visitor.visit_print_stmt_node(self)
    end
  end
end
