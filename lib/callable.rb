# frozen_string_literal: true

class Callable
  def initialize(params, body)
    @params = params
    @body = body
  end

  def call(evaluator, arguments)
    environment = Environment.new(evaluator.globals)
    @params.each_with_index { |param, i| environment.define(param.lexeme, arguments[i]) }
    evaluator.visit_block_node(@body, environment)
  end
end
