# frozen_string_literal: true

module Node
  class Set
    attr_reader :object, :name, :value

    def initialize(object, name, value)
      @object = object
      @name = name
      @value = value
    end

    def accept(visitor)
      visitor.visit_set_node(self)
    end
  end
end
