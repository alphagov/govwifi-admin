module Gateways
  class OrganisationNames
    def fetch_names
      Organisation.pluck(:name)
    end
  end
end
