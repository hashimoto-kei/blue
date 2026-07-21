# frozen_string_literal: true

class Return < StandardError
  attr_reader :value

  def initialize(value)
    @value = value
  end
end
