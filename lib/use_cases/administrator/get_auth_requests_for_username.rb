module UseCases
  module Administrator
    class GetAuthRequestsForUsername
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(username:)
        return [] if username_invalid?(username)

        @authentication_logs_gateway.search(username: username)
      end

    private

      def username_invalid?(username)
        username.nil? || username.empty? || username.length != 6
      end
    end
  end
end
