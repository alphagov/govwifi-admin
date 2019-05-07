module UseCases
  module Administrator
    class PublishOrganisationNames
      def initialize(destination_gateway:, source_gateway:, presenter:)
        @destination_gateway = destination_gateway
        @source_gateway = source_gateway
        @presenter = presenter
      end

      def execute
        payload = presenter.execute(source_gateway.fetch_names)
        destination_gateway.write(data: payload)
      end

    private

      attr_reader :destination_gateway, :source_gateway, :presenter
    end
  end
end
