# frozen_string_literal: true

class FailedServiceError < StandardError
  attr_reader :payload

  def initialize(payload)
    super

    @payload = payload
  end
end
