module Gateways
  class OrganisationsWhitelist
    def fetch_domains
      Organisation.pluck(:name)
    end
  end
end
