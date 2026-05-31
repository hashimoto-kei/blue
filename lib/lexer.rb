# frozen_string_literal: true

require_relative 'error'
require_relative 'token'

class Lexer
  def initialize(source)
    @source = source
    @start = 0
    @current = 0
    @line = 1
    @tokens = []
  end

  def scan_tokens
    until end?
      @start = @current
      scan_token
    end
    add_token(:eof)
    @tokens
  end

  private

  def end?
    @current >= @source.size
  end

  def advance
    c = @source[@current]
    @current += 1
    c
  end

  def peek
    @source[@current]
  end

  def match?(expected)
    matched = (peek == expected)
    advance if matched
    matched
  end

  def add_token(type, literal=nil)
    lexeme = end? ? '' : @source[@start...@current]
    @tokens << Token.new(type, @line, lexeme, literal)
  end

  def scan_token
    c = advance
    case c
    in ' ' | /\t/ | /\r/ | /\f/ | /\v/
      # do nothing (skip white space)
    in /\n/
      @line += 1
    in '+' | '-' | '*'
      add_token(c.to_sym)
    in '='
      type = match?('=') ? :eq : '='.to_sym
      add_token(type)
    in '!'
      type = match?('=') ? :nq : '!'.to_sym
      add_token(type)
    in '/'
      c = peek
      case c
      in '/'
        advance until (peek == "\n" || end?)
      else
        add_token('/'.to_sym)
      end
    in /\d/
      number
    else
      Error.report(@line, "Unexpected character: #{c}")
    end
  end

  def number
    while peek =~ /\d/
      advance
    end
    lexeme = @source[@start...@current]
    literal = lexeme.to_f
    add_token(:number, literal)
  end
end
