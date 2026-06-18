# frozen_string_literal: true

module Node
  class Variable
    attr_reader :var

    def initialize(var)
      @var = var
    end

    def accept(visitor)
      visitor.visit_variable_node(self)
    end
  end
end
