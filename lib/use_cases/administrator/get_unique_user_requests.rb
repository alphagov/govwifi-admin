module UseCases
  module Administrator
    class GetUniqueUserRequests
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(date_range: nil)
        { connection_count: @authentication_logs_gateway.unique_user_count(date_range: date_range) }
      end
    end
  end
end
