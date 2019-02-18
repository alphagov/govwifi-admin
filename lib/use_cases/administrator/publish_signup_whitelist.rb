module UseCases
  module Administrator
    class PublishSignupWhitelist
      def initialize(destination_gateway:, source_gateway:, presenter:)
        @destination_gateway = destination_gateway
        @source_gateway = source_gateway
        @presenter = presenter
      end

      def execute
        payload = presenter.execute(source_gateway.fetch_domains)
        destination_gateway.upload(data: payload)
      end

    private

      attr_reader :destination_gateway, :source_gateway, :presenter
    end
  end
end
