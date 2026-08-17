# frozen_string_literal: true

require_relative 'evaluator'
require_relative 'lexer'
require_relative 'parser'
require_relative 'resolver'

class Interpreter
  def initialize(path)
    @source = File.open(path) { |file| file.read }
  end

  def execute
    lexer = Lexer.new(@source)
    tokens = lexer.scan_tokens
    parser = Parser.new(tokens)
    node = parser.parse
    evaluator = Evaluator.new
    resolver = Resolver.new(evaluator)
    resolver.resolve(node)
    evaluator.evaluate(node)
  end
end
