# frozen_string_literal: true

class Environment
  def initialize
    @variables = {}
  end

  def define(name, value)
    @variables[name] = value
  end

  def assign(name, value)
    unless @variables.key?(name)
      raise "Undefined variable: '#{name}'."
    end
    @variables[name] = value
  end

  def get(name)
    if @variables.key?(name)
      return @variables[name]
    end
    raise "Undefined variable: '#{name}'."
  end
end
