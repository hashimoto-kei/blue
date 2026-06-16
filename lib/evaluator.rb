# frozen_string_literal: true

class Evaluator
  def evaluate(node)
    node.accept(self)
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
      ! rhd
    end
  end

  def visit_literal_node(node)
    node.literal
  end
end
