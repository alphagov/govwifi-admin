class ConfirmationUseCaseSpy
  @@last_confirmation_url = nil
  @@confirmations_count = 0

  class << self
    def last_confirmation_url
      @@last_confirmation_url
    end

    def confirmations_count
      @@confirmations_count
    end
  end

  def execute(email:, confirmation_url:)
    @@last_confirmation_url = confirmation_url

    {}
  end

  private

  attr_reader :notifications_gateway
end