# frozen_string_literal: true

require_relative 'callable'
require_relative 'environment'
require_relative 'return'

class Evaluator
  attr_reader :globals

  def initialize
    @globals = Environment.new
    @environment = @globals
    define_native_functions
  end

  def evaluate(node)
    node.accept(self)
  end

  def visit_program_node(node)
    node.statements.each do |statement|
      evaluate(statement)
    end
  end

  def visit_block_node(node, environment=nil)
    previous_env = @environment
    @environment = environment.nil? ? Environment.new(@environment) : environment
    value = nil
    node.statements.each do |statement|
      value = evaluate(statement)
    end
    value
  ensure
    @environment = previous_env
  end

  def visit_expr_stmt_node(node)
    evaluate(node.expr)
  end

  def visit_if_stmt_node(node)
    condition = evaluate(node.condition)
    if condition
      evaluate(node.then_body)
    elsif !node.else_body.nil?
      evaluate(node.else_body)
    end
  end

  def visit_while_stmt_node(node)
    while evaluate(node.condition)
      evaluate(node.body)
    end
  end

  def visit_return_stmt_node(node)
    value = node.value.nil? ? nil : evaluate(node.value)
    raise Return.new(value)
  end

  def visit_print_stmt_node(node)
    puts evaluate(node.expr)
  end

  def visit_var_declaration_node(node)
    name = node.lhs.lexeme
    value = node.rhs.nil? ? nil : evaluate(node.rhs)
    @environment.define(name, value)
  end

  def visit_func_declaration_node(node)
    name = node.name.lexeme
    callable = Callable.new(node.params, node.body)
    @environment.define(name, callable)
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

  def visit_call_node(node)
    function = evaluate(node.callee)
    arguments = node.arguments.map { |argument| evaluate(argument) }
    function.call(self, arguments)
  rescue Return => e
    e.value
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

  def visit_logical_node(node)
    lhs = evaluate(node.lhs)
    case node.op.type
    in :and
      lhs && evaluate(node.rhs)
    in :or
      lhs || evaluate(node.rhs)
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

  private

  def define_native_functions
    @globals.define(
      'clock',
      Class.new do
        def call(*) = Process.clock_gettime(Process::CLOCK_REALTIME, :second)
      end.new
    )
    @globals.define(
      'sleep',
      Class.new do
        def call(_, arguments) = Kernel.sleep(arguments[0])
      end.new
    )
  end
end
