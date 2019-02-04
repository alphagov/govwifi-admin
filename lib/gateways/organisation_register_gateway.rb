require 'httparty'
require 'json'

module Gateways
  class OrganisationRegisterGateway

    def fetch_organisations
      government_orgs_url = "#{SITE_CONFIG['organisation_register_url']}/records.json?page-size=5000"
      local_auth_url = "#{SITE_CONFIG['local_auth_register_url']}/records.json?page-size=5000"

      government_register_response = HTTParty.get(government_orgs_url)
      local_auth_register_response = HTTParty.get(local_auth_url)

      parsed_government_register = JSON.parse(government_register_response.body)
      parsed_local_auth_register = JSON.parse(local_auth_register_response.body)

      gov_register = parsed_government_register.map do |_, value|
        value['item'].first['name']
      end

      local_auth_register = parsed_local_auth_register.map do |_, value|
        value['item'].first['official-name']
      end

      final_register = gov_register << local_auth_register
      flattened_register = final_register.flatten

      return flattened_register

    end
  end
end
