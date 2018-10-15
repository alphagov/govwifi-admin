module UseCases
  module Administrator
    class GetAuthRequestsForUsername
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(username:)
        return error if invalid_username?(username)

        results(username)
      end

    private

      def error
        { error: 'Username must be 6 characters in length.', results: [] }
      end

      def invalid_username?(username)
        username.nil? || username.empty? || username.length != 6
      end

      def results(username)
        { error: nil, results: @authentication_logs_gateway.search(username: username) }
      end
    end
  end
end
