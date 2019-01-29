require 'httparty'
require 'json'

module Gateways
  class OrganisationRegisterGateway
    REGISTER_URL = "#{SITE_CONFIG['registers_url']}/records.json?page-size=5000".freeze

    def fetch_organisations
      response = HTTParty.get(REGISTER_URL)
      parsed_json = JSON.parse(response.body)

      parsed_json.map do |_, value|
        value['item'].first['name']
      end
    end
  end
end
