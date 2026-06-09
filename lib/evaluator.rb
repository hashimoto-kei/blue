# frozen_string_literal: true

class Evaluator
  def evaluate(node)
    node.accept(self)
  end

  def visit_binary_node(node)
    lhs = node.lhs.accept(self)
    rhs = node.rhs.accept(self)
    case node.op.type
    in :+
      lhs + rhs
    in :-
      lhs - rhs
    in :*
      lhs * rhs
    in :/
      lhs / rhs
    end
  end

  def visit_unary_node(node)
    rhs = node.rhs.accept(self)
    case node.op.type
    in :-
      - rhd
    in :!
      ! rhd
    end
  end

  def visit_literal_node(node)
    node.literal
  end
end
