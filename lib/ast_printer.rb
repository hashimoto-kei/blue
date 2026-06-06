# frozen_string_literal: true

class AstPrinter
  def print(node)
    node.accept(self)
  end

  def visit_binary_node(node)
    "(#{node.op.lexeme} #{node.lhs.accept(self)} #{node.rhs.accept(self)})"
  end

  def visit_unary_node(node)
    "(#{node.op.lexeme} #{node.rhs.accept(self)})"
  end

  def visit_literal_node(node)
    "#{node.literal}"
  end
end
