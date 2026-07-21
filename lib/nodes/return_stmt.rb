# frozen_string_literal: true

module Node
  class ReturnStmt
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def accept(visitor)
      visitor.visit_return_stmt_node(self)
    end
  end
end
