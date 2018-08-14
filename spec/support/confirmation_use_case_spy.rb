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

    def clear!
      @@last_confirmation_url = nil
      @@confirmations_count = 0
    end
  end

  def execute(email:, confirmation_url:)
    @@last_confirmation_url = confirmation_url
    @@confirmations_count += 1

    {}
  end
end