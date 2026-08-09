# frozen_string_literal: true

class Environment
  attr_reader :variables, :enclosing

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

  def assign_at(distance, name, value)
    ancestor(distance).variables[name] = value
  end

  def get_at(distance, name)
    ancestor(distance).variables[name]
  end

  private

  def ancestor(distance)
    environment = self
    distance.times do
      environment = environment.enclosing
    end
    environment
  end
end
