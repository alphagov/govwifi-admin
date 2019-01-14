module UseCases
  module Administrator
    class GetAuthRequests
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(username: nil, ip: nil)
        { results: @authentication_logs_gateway.search(username: username, ip: ip), connection_count: @authentication_logs_gateway.count_distinct_users(ips: ip) }
      end
    end
  end
end
