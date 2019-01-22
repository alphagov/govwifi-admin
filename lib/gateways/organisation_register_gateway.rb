require 'net/http'
require 'json'

module Gateways
  class OrganisationRegisterGateway
    REGISTER_URL = 'https://government-organisation.register.gov.uk/records.json?page-size=5000'.freeze

    def fetch_organisations
      uri = URI(REGISTER_URL)
      response = Net::HTTP.get(uri)
      parsed_json = JSON.parse(response)

      parsed_json.map do |_, value|
        value['item'].first['name']
      end
    end
  end
end
