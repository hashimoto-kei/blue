# frozen_string_literal: true

require_relative 'instance'

class Klass
  def initialize(name)
    @name = name
  end

  def call(evaluator, arguments)
    Instance.new(self)
  end
end
