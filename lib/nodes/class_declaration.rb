# frozen_string_literal: true

module Node
  class ClassDeclaration
    attr_reader :name

    def initialize(name, methods)
      @name = name
      @methods = methods
    end

    def accept(visitor)
      visitor.visit_class_declaration_node(self)
    end
  end
end
