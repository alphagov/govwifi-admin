module Gateways
  class OrganisationRegisterGateway
    def fetch_organisations
      url = "https://government-organisation.register.gov.uk/records.json?page-size=5000"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      parsed_json = JSON.parse(response)

      parsed_json.map do |_, value|
        value['item'].first['name']
      end
    end
  end
end
