module Gateways
  class LoggingApi
    LOGGING_API_SEARCH_ENDPOINT = "http://govwifi-logging-api.com/authentication/events/search/".freeze

    def search(username:)
      return [] if username.nil? || username.empty?

      uri = URI(LOGGING_API_SEARCH_ENDPOINT + username)
      response = Net::HTTP.get_response(uri)

      JSON.parse(response.body)
    end
  end
end
