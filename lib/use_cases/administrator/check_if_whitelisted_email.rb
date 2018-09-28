module UseCases
  module Administrator
    class CheckIfWhitelistedEmail
      def execute(email)
        pattern = ENV.fetch('AUTHORISED_EMAIL_DOMAINS_REGEX')
        checker = Regexp.new(pattern, Regexp::IGNORECASE)

        { success: email.to_s.match?(checker) }
      end
    end
  end
end
