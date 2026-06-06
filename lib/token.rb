# frozen_string_literal: true

class Token
  attr_reader :type, :lexeme, :literal

  def initialize(type, line, lexeme, literal)
    @type = type
    @line = line
    @lexeme = lexeme
    @literal = literal
  end

  def to_s
    "{type: #{@type}, lexeme: #{@lexeme}, literal: #{@literal}}"
  end
end
