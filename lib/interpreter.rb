# frozen_string_literal: true

require_relative 'evaluator'
require_relative 'lexer'
require_relative 'parser'

class Interpreter
  def initialize(path)
    @source = File.open(path) { |file| file.read }
  end

  def execute
    lexer = Lexer.new(@source)
    tokens = lexer.scan_tokens
    parser = Parser.new(tokens)
    nodes = parser.parse
    evaluator = Evaluator.new
    nodes.each do |node|
      puts evaluator.evaluate(node)
    end
  end
end
