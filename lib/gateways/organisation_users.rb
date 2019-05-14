module Gateways
  class OrganisationUsers
    def initialize(organisation:)
      @organisation = organisation
    end

    def fetch
      @organisation.users.merge(@organisation.invited_users)
    end
  end
end
