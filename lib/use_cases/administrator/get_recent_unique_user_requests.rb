module UseCases
  module Administrator
    class GetRecentUniqueUserRequests
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute
        { connection_count: @authentication_logs_gateway.unique_user_count }
      end
    end
  end
end
