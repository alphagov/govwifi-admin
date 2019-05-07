module Gateways
  class OrganisationsWhitelist
    def fetch_names
      Organisation.pluck(:name)
    end
  end
end
