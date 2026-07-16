# frozen_string_literal: true

require_relative 'nodes/assign'
require_relative 'nodes/binary'
require_relative 'nodes/block'
require_relative 'nodes/call'
require_relative 'nodes/expr_stmt'
require_relative 'nodes/func_declaration'
require_relative 'nodes/if_stmt'
require_relative 'nodes/literal'
require_relative 'nodes/logical'
require_relative 'nodes/print_stmt'
require_relative 'nodes/program'
require_relative 'nodes/unary'
require_relative 'nodes/var_declaration'
require_relative 'nodes/variable'
require_relative 'nodes/while_stmt'

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
      Error.report(peek.line, "Invalid token; expected: #{tokens}, actual: #{peek.type}")
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
  #          | while_statement
  #          | for_statement
  #          | print_statement
  #          | var_declaration
  #          | block
  def statement
    if match?(:if)
      return if_statement
    end
    if match?(:while)
      return while_statement
    end
    if match?(:for)
      return for_statement
    end
    if match?(:print)
      return print_statement
    end
    if match?(:var)
      return var_declaration
    end
    if match?(:func)
      return func_declaration
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

  # while_statement: "while" "(" expression ")" statement
  def while_statement
    consume(:'(')
    conditon = expression
    consume(:')')
    body = statement
    node = Node::WhileStmt.new(conditon, body)
  end

  # for_statement: "for" "(" (var_declaration | ";") expression? ";" expression? ")" statement
  def for_statement
    consume(:'(')
    initializer = nil
    unless match?(:';')
      consume(:var)
      initializer = var_declaration
    end
    condition = nil
    if match?(:';')
      condition = Node::Literal.new(true)
    else
      condition = expression
      consume(:';')
    end
    increment = nil
    unless match?(:')')
      increment = expression
      consume(:')')
    end
    body = statement
    block = Node::Block.new([body, increment].compact)
    while_stmt = Node::WhileStmt.new(condition, block)
    node = Node::Block.new([initializer, while_stmt].compact)
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

  # func_declaration: "func" funcion
  def func_declaration = funcion

  # funcion: identifier "(" parameters? ")" block
  def funcion
    name = consume(:identifier)
    consume(:'(')
    params = match?(:')') ? [] : parameters
    consume(:'{')
    body = block
    Node::FuncDeclaration.new(name, params, body)
  end

  # parameters: identifier ( "," identifier )*
  def parameters
    params = [consume(:identifier)]
    until match?(:')')
      consume(:',')
      params << consume(:identifier)
    end
    params
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
  #           | logical_or
  def assignment
    node = logical_or
    if match?(:'=')
      rhs = assignment
      node = Node::Assign.new(node, rhs)
    end
    node
  end

  # logical_or: logical_and ("or" logical_and)*
  def logical_or
    node = logical_and
    while match?(:or)
      op = previous_token
      rhs = logical_and
      node = Node::Logical.new(op, node, rhs)
    end
    node
  end

  # logical_and: equality ("and" equality)*
  def logical_and
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
  #        | call
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
      node = Node::Variable.new(previous_token)
      return match?(:'(') ? call(node) : node
    end
    if match?(:'(')
      node = expression
      consume(:')')
      node
    end
  end

  # call: identifier ( "(" arguments? ")" )+
  def call(callee)
    rhs = match?(:')') ? [] : arguments
    Node::Call.new(callee, rhs)
  end

  # arguments: expression ( "," expression )*
  def arguments
    expressions = [expression]
    until match?(:')')
      consume(:',')
      expressions << expression
    end
    expressions
  end
end
