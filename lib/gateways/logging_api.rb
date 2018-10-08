module Gateways
  class LoggingApi
    LOGGING_API_SEARCH_ENDPOINT = ENV['LOGGING_API_SEARCH_ENDPOINT'].freeze

    def search(username:)
      return [] if username_invalid?(username)

      uri = URI(LOGGING_API_SEARCH_ENDPOINT + username)
      response = Net::HTTP.get_response(uri)

      JSON.parse(response.body)
    end

  private

    def username_invalid?(username)
      username.nil? || username.empty? || username.length != 6
    end
  end
end
