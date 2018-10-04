module Gateways
  class LoggingApi
    LOGGING_API_SEARCH_ENDPOINT = "http://govwifi-logging-api.com/authentication/events/search".freeze

    def search(username:)
      return [] if username.nil? || username.empty?

      uri = URI(LOGGING_API_SEARCH_ENDPOINT)
      params = { username: username }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      response.body
    end
  end
end
