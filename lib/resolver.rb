# frozen_string_literal: true

class Resolver
  def initialize(evaluator)
    @evaluator = evaluator
    @scopes = []
  end

  def resolve(node)
    node.accept(self)
  end

  def visit_program_node(node)
    node.statements.each do |statement|
      resolve(statement)
    end
  end

  def visit_block_node(node, new_scope: true)
    begin_scope if new_scope
    node.statements.each do |statement|
      resolve(statement)
    end
    end_scope if new_scope
  end

  def visit_expr_stmt_node(node)
    resolve(node.expr)
  end

  def visit_if_stmt_node(node)
    resolve(node.condition)
    resolve(node.then_body)
    if !node.else_body.nil?
      resolve(node.else_body)
    end
  end

  def visit_while_stmt_node(node)
    resolve(node.condition)
    resolve(node.body)
  end

  def visit_return_stmt_node(node)
    unless node.value.nil?
      resolve(node.value)
    end
  end

  def visit_print_stmt_node(node)
    resolve(node.expr)
  end

  def visit_var_declaration_node(node)
    name = node.lhs.lexeme
    declare(name)
    resolve(node.rhs) unless node.rhs.nil?
    define(name)
  end

  def visit_func_declaration_node(node)
    name = node.name.lexeme
    declare(name)
    define(name)
    resolve_function(node)
  end

  def visit_variable_node(node)
    name = node.var.lexeme
    if @scopes.last&.key?(name) && !@scopes.last[name]
      raise 'Syntax error: cannot read variable in its initializer.'
    end
    resolve_local(name, node)
  end

  def visit_assign_node(node)
    resolve(node.rhs)
    name = node.lhs.var.lexeme
    resolve_local(name, node)
  end

  def visit_call_node(node)
    resolve(node.callee)
    node.arguments.each { |argument| resolve(argument) }
  end

  def visit_binary_node(node)
    resolve(node.lhs)
    resolve(node.rhs)
  end

  def visit_logical_node(node)
    resolve(node.lhs)
    resolve(node.rhs)
  end

  def visit_unary_node(node)
    resolve(node.rhs)
  end

  def visit_literal_node(node)
    # do nothing
  end

  private

  def begin_scope
    @scopes << {}
  end

  def end_scope
    @scopes.pop
  end

  def declare(name)
    raise "Syntax error: variable '#{name}' already declared in this scope." if @scopes.last&.key?(name)
    @scopes.last[name] = false unless @scopes.empty?
  end

  def define(name)
    @scopes.last[name] = true unless @scopes.empty?
  end

  def resolve_local(name, node)
    @scopes.reverse.each_with_index do |scope, distance|
      if scope.key?(name)
        @evaluator.resolve(node, distance)
        break
      end
    end
  end

  def resolve_function(node)
    begin_scope
    node.params.each do |param|
      name = param.lexeme
      declare(name)
      define(name)
    end
    visit_block_node(node.body, new_scope: false)
    end_scope
  end
end
