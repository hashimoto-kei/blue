# frozen_string_literal: true

require_relative 'instance'

class Klass
  def initialize(name, methods)
    @name = name
    @methods = methods
  end

  def call(evaluator, arguments)
    instance = Instance.new(self)
    constructor = find_method('init')
    constructor.bind(instance).call(evaluator, arguments) unless constructor.nil?
    instance
  end

  def find_method(name)
    @methods[name]
  end
end
