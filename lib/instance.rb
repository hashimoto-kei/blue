# frozen_string_literal: true

class Instance
  def initialize(klass)
    @klass = klass
    @fields = {}
  end

  def get(name)
    return @fields[name] if @fields.key?(name)
    method = @klass.find_method(name)
    return method.bind(self) unless method.nil?
    raise "Undefined property #{name}"
  end

  def set(name, value)
    @fields[name] = value
  end
end
