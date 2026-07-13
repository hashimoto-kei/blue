# frozen_string_literal: true

module Node
  class Call
    attr_reader :callee, :arguments

    def initialize(callee, arguments)
      @callee = callee
      @arguments = arguments
    end

    def accept(visitor)
      visitor.visit_call_node(self)
    end
  end
end
