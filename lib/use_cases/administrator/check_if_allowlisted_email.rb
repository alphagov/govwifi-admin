module UseCases
  module Administrator
    class CheckIfAllowlistedEmail
      def self.execute(email)
        regexp = Gateways::S3.new(**Gateways::S3::DOMAIN_REGEXP).read
        pattern = Regexp.new(regexp, Regexp::IGNORECASE)

        email.to_s.match?(pattern)
      end
    end
  end
end
