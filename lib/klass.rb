# frozen_string_literal: true

require_relative 'instance'

class Klass
  def initialize(name, methods)
    @name = name
    @methods = methods
  end

  def call(evaluator, arguments)
    Instance.new(self)
  end

  def find_method(name)
    @methods[name]
  end
end
