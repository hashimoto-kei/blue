# frozen_string_literal: true

module Node
  class This
    attr_reader :keyword

    def initialize(keyword)
      @keyword = keyword
    end

    def accept(visitor)
      visitor.visit_this_node(self)
    end
  end
end
