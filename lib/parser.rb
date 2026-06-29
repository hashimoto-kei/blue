# frozen_string_literal: true

require_relative 'nodes/assign'
require_relative 'nodes/binary'
require_relative 'nodes/block'
require_relative 'nodes/expr_stmt'
require_relative 'nodes/if_stmt'
require_relative 'nodes/literal'
require_relative 'nodes/logical'
require_relative 'nodes/print_stmt'
require_relative 'nodes/program'
require_relative 'nodes/unary'
require_relative 'nodes/var_declaration'
require_relative 'nodes/variable'

class Parser
  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse = program

  private

  def end?
    @current >= @tokens.size
  end

  def advance
    token = @tokens[@current]
    @current += 1
    token
  end

  def peek
    @tokens[@current]
  end

  def previous_token
    @tokens[@current - 1]
  end

  def match?(*tokens)
    matched = (tokens.include?(peek.type))
    advance if matched
    matched
  end

  def consume(*tokens)
    unless match?(*tokens)
      Error.report(peek.line, "Unexpected token: #{peek.type}")
    end
    previous_token
  end

  # program: statement* "eof"
  def program
    statements = []
    until match?(:eof)
      statements << statement
    end
    node = Node::Program.new(statements)
  end

  # statement: expression_statement
  #          | if_statement
  #          | print_statement
  #          | var_declaration
  #          | block
  def statement
    if match?(:if)
      return if_statement
    end
    if match?(:print)
      return print_statement
    end
    if match?(:var)
      return var_declaration
    end
    if match?(:'{')
      return block
    end
    expression_statement
  end

  # expression_statement: expression ";"
  def expression_statement
    node = expression
    consume(:';')
    node = Node::ExprStmt.new(node)
  end

  # if_statement: "if" "(" expression ")" statement ("else" statement)?
  def if_statement
    consume(:'(')
    conditon = expression
    consume(:')')
    then_body = statement
    else_body = nil
    if match?(:else)
      else_body = statement
    end
    node = Node::IfStmt.new(conditon, then_body, else_body)
  end

  # print_statement: print expression ";"
  def print_statement
    node = expression
    consume(:';')
    node = Node::PrintStmt.new(node)
  end

  # var_declaration: "var" identifier ("=" expression)? ";"
  def var_declaration
    node = consume(:identifier)
    rhs = nil
    if match?(:'=')
      rhs = expression
    end
    consume(:';')
    node = Node::VarDeclaration.new(node, rhs)
  end

  # block: "{" statement* "}"
  def block
    statements = []
    until match?(:'}')
      statements << statement
    end
    node = Node::Block.new(statements)
  end

  # expression: assignment
  def expression = assignment

  # assignment: identifier "=" assignment
  #           | logic_and
  def assignment
    node = logic_and
    if match?(:'=')
      rhs = assignment
      node = Node::Assign.new(node, rhs)
    end
    node
  end

  # logic_and: equality ("and" equality)*
  def logic_and
    node = equality
    while match?(:and)
      op = previous_token
      rhs = equality
      node = Node::Logical.new(op, node, rhs)
    end
    node
  end

  # equality: comparison ( ( "==" | "!=" ) comparison )*
  def equality
    node = comparison
    while match?(:==, :!=)
      op = previous_token
      rhs = comparison
      node = Node::Binary.new(op, node, rhs)
    end
    node
  end

  # comparison: term ( ( ">" | ">=" | "<" | "<=" ) term )*
  def comparison
    node = term
    while match?(:>, :>=, :<, :<=)
      op = previous_token
      rhs = term
      node = Node::Binary.new(op, node, rhs)
    end
    node
  end

  # term: factor ( ( "+" | "-" ) factor )*
  def term
    node = factor
    while match?(:+, :-)
      op = previous_token
      rhs = factor
      node = Node::Binary.new(op, node, rhs)
    end
    node
  end

  # factor: unary ( ( "*" | "/" ) unary )*
  def factor
    node = unary
    while match?(:*, :/)
      op = previous_token
      rhs = unary
      node = Node::Binary.new(op, node, rhs)
    end
    node
  end

  # unary: ( "-" | "!" ) unary
  #      | primary
  def unary
    if match?(:-, :!)
      op = previous_token
      rhs = unary
      node = Node::Unary.new(op, rhs)
    else
      node = primary
    end
    node
  end

  # primary: number
  #        | string
  #        | "true"
  #        | "false"
  #        | "null"
  #        | identifier
  #        | "(" expression ")"
  def primary
    if match?(:number, :string)
      return Node::Literal.new(previous_token.literal)
    end
    if match?(:true)
      return Node::Literal.new(true)
    end
    if match?(:false)
      return Node::Literal.new(false)
    end
    if match?(:null)
      return Node::Literal.new(nil)
    end
    if match?(:identifier)
      return Node::Variable.new(previous_token)
    end
    if match?(:'(')
      node = expression
      consume(:')')
      node
    end
  end
end
