module UseCases
  module Administrator
    class GetAuthRequests
      def initialize(authentication_logs_gateway:)
        @authentication_logs_gateway = authentication_logs_gateway
      end

      def execute(username: nil, ips: nil)
        params = username.present? ? { username: username } : { ips: ips }

        {
          results: @authentication_logs_gateway.search(params)
        }
      end
    end
  end
end
