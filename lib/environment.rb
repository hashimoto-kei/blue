# frozen_string_literal: true

class Environment
  def initialize
    @variables = {}
  end

  def define(name, value)
    @variables[name] = value
  end

  def get(name)
    unless @variables.key?(name)
      raise "Undefined variable: '#{name}'."
    end
    @variables[name]
  end
end
