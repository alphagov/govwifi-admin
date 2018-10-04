module Gateways
  class LoggingApi
    def search(username:)
      return [] if username.nil? || username.empty?
      
      uri = URI('http://govwifi-logging-api.com/authentication/events/search')
      params = { username: "tom" }
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      response.body
    end
  end
end
