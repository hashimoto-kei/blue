# frozen_string_literal: true

class Error
  def self.report(line, message)
    puts "[line #{line}] Error: #{message}"
  end
end
