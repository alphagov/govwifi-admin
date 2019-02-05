module UseCases
  module Organisation
    class FetchOrganisationRegister
      def initialize(organisations_gateway:)
        @organisations_gateway = organisations_gateway
      end

      def execute
        organisations_gateway.all_organisations
      end

    private

      attr_reader :organisations_gateway
    end
  end
end
