module UseCases
  module Organisation
    class FetchOrganisationRegister
      def initialize(govuk_organisations_register_gateway:)
        @govuk_organisations_register_gateway = govuk_organisations_register_gateway
      end

      def execute
        government_orgs = govuk_organisations_register_gateway.government_orgs
        local_authorities = govuk_organisations_register_gateway.local_authorities
        government_orgs + local_authorities
      end

    private

      attr_reader :govuk_organisations_register_gateway
    end
  end
end
