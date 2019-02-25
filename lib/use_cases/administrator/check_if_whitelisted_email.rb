module UseCases
  module Administrator
    class CheckIfWhitelistedEmail
      def initialize(gateway:)
        @gateway = gateway
      end

      def execute(email)
        result = gateway.read

        pattern = Regexp.new(result, Regexp::IGNORECASE)

        { success: email.to_s.match?(pattern) }
      end

    private

      attr_reader :gateway
    end
  end
end
