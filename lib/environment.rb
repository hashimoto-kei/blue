# frozen_string_literal: true

class Environment
  def initialize(enclosing=nil)
    @variables = {}
    @enclosing = enclosing
  end

  def define(name, value)
    @variables[name] = value
  end

  def assign(name, value)
    if @variables.key?(name)
      return @variables[name] = value
    end
    unless @enclosing.nil?
      return @enclosing.assign(name, value)
    end
    raise "Undefined variable: '#{name}'."
  end

  def get(name)
    if @variables.key?(name)
      return @variables[name]
    end
    unless @enclosing.nil?
      return @enclosing.get(name)
    end
    raise "Undefined variable: '#{name}'."
  end
end
