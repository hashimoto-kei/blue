# frozen_string_literal: true

module Node
  class Program
    attr_reader :statements

    def initialize(statements)
      @statements = statements
    end

    def accept(visitor)
      visitor.visit_program_node(self)
    end
  end
end
