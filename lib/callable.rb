# frozen_string_literal: true

class Callable
  def initialize(params, body, closure)
    @params = params
    @body = body
    @closure = closure
  end

  def call(evaluator, arguments)
    environment = Environment.new(@closure)
    @params.each_with_index { |param, i| environment.define(param.lexeme, arguments[i]) }
    evaluator.visit_block_node(@body, environment)
  end
end
