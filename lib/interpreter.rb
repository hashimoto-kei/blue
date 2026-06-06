# frozen_string_literal: true

require_relative 'ast_printer'
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
    node = parser.parse
    printer = AstPrinter.new
    puts printer.print(node)
  end
end
