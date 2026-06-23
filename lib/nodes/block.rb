# frozen_string_literal: true

module Node
  class Block
    attr_reader :statements

    def initialize(statements)
      @statements = statements
    end

    def accept(visitor)
      visitor.visit_block_node(self)
    end
  end
end
