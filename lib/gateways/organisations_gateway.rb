require 'httparty'
require 'json'

module Gateways
  class OrganisationsGateway
    def all_organisations
      final_register = government_orgs << local_authorities
      flattened_register = final_register.flatten
      flattened_register
    end

    def government_orgs
      government_orgs_url = SITE_CONFIG['organisation_register_url']
      government_register_response = HTTParty.get(government_orgs_url)
      parsed_government_register = JSON.parse(government_register_response.body)

      parsed_government_register.map do |_, value|
        value['item'].first['name']
      end
    end

    def local_authorities
      local_auth_url = SITE_CONFIG['local_auth_register_url']
      local_auth_register_response = HTTParty.get(local_auth_url)
      parsed_local_auth_register = JSON.parse(local_auth_register_response.body)

      parsed_local_auth_register.map do |_, value|
        value['item'].first['official-name']
      end
    end
  end
end
