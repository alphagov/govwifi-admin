module UseCases
  module Administrator
    class GetAuthRequestsForUsername
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(username:)
        @authentication_logs_gateway.search(username: username)
      end
    end
  end
end
