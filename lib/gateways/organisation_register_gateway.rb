require 'httparty'
require 'json'

module Gateways
  class OrganisationRegisterGateway
    GOVERNMENT_ORGS_URL = "#{SITE_CONFIG['organisation_register_url']}/records.json?page-size=5000".freeze
    LOCAL_AUTH_URL = "#{SITE_CONFIG['local_auth_url']}/records.json?page-size=5000".freeze

    def fetch_organisations
      government_register_response = HTTParty.get(GOVERNMENT_ORGS_URL
      local_auth_register_response = HTTParty.get(LOCAL_AUTH_URL)

      parsed_government_register = JSON.parse(government_register_response.body)
      parsed_local_auth_register= JSON.parse(local_auth_register_response.body)


      parsed_government_register.map do |_, value|
        value['item'].first['name']
      end
    end
  end
end
