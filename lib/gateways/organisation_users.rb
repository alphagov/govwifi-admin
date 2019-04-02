module Gateways
  class OrganisationUsers
    def initialize(organisation:)
      @organisation = organisation
    end

    def fetch
      @organisation.users
    end
  end
end
