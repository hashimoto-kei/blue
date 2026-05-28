# frozen_string_literal: true

require_relative 'lexer'

class Interpreter
  def initialize(path)
    source = File.open(path) { |file| file.read }
    @lexer = Lexer.new(source)
  end

  def execute
    tokens = @lexer.scan_tokens
    tokens.each { |token| puts token }
  end
end
