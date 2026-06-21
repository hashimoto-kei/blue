# frozen_string_literal: true

require_relative 'environment'

class Evaluator
  def initialize
    @environment = Environment.new
  end

  def evaluate(node)
    node.accept(self)
  end

  def visit_expr_stmt_node(node)
    evaluate(node.expr)
  end

  def visit_print_stmt_node(node)
    puts evaluate(node.expr)
  end

  def visit_var_declaration_node(node)
    name = node.lhs.lexeme
    value = node.rhs.nil? ? nil : evaluate(node.rhs)
    @environment.define(name, value)
  end

  def visit_variable_node(node)
    name = node.var.lexeme
    @environment.get(name)
  end

  def visit_assign_node(node)
    name = node.lhs.var.lexeme
    value = evaluate(node.rhs)
    @environment.assign(name, value)
  end

  def visit_binary_node(node)
    lhs = evaluate(node.lhs)
    rhs = evaluate(node.rhs)
    case node.op.type
    in :+
      lhs + rhs
    in :-
      lhs - rhs
    in :*
      lhs * rhs
    in :/
      lhs / rhs
    in :==
      lhs == rhs
    in :!=
      lhs != rhs
    in :>
      lhs > rhs
    in :>=
      lhs >= rhs
    in :<
      lhs < rhs
    in :<=
      lhs <= rhs
    end
  end

  def visit_unary_node(node)
    rhs = evaluate(node.rhs)
    case node.op.type
    in :-
      - rhs
    in :!
      ! rhs
    end
  end

  def visit_literal_node(node)
    node.literal
  end
end
