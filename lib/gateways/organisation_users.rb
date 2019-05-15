module Gateways
  class OrganisationUsers
    def initialize(organisation:)
      @organisation = organisation
    end

    def fetch
      @organisation.team_list
    end
  end
end
