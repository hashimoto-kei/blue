# frozen_string_literal: true

module Node
  class Get
    attr_reader :object, :name

    def initialize(object, name)
      @object = object
      @name = name
    end

    def accept(visitor)
      visitor.visit_get_node(self)
    end
  end
end
