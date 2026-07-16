# frozen_string_literal: true

module Node
  class FuncDeclaration
    attr_reader :name, :params, :body

    def initialize(name, params, body)
      @name = name
      @params = params
      @body = body
    end

    def accept(visitor)
      visitor.visit_func_declaration_node(self)
    end
  end
end
