module UseCases
  module Administrator
    class GetAuthRequests
      def initialize(authentication_logs_gateway:, search_validator:)
        @authentication_logs_gateway = authentication_logs_gateway
        @search_validator = search_validator
      end

      def execute(username: nil, ip: nil)
        return error unless valid_search?(username, ip)

        results(username, ip)
      end

    private

      def valid_search?(username, ip)
        @search_validator.execute(username: username, ip: ip).fetch(:success)
      end

      def error
        { error: 'There was a problem with your search', results: [] }
      end

      def results(username, ip)
        {
          error: nil,
          results: @authentication_logs_gateway.search(username: username, ip: ip)
        }
      end
    end
  end
end
