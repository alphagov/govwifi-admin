module UseCases
  module Administrator
    class GetLogsForUsername
      def initialize(gateway:)
        @logging_api_gateway = gateway
      end

      def execute(username:)
        @logging_api_gateway.search(username: username)
      end
    end
  end
end
