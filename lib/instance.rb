# frozen_string_literal: true

class Instance
  def initialize(klass)
    @klass = klass
    @fields = {}
  end

  def get(name)
    raise "Undefined property #{name}" unless (@fields.key?(name) || @klass.find_method(name))
    @fields[name] || @klass.find_method(name)
  end

  def set(name, value)
    @fields[name] = value
  end
end
