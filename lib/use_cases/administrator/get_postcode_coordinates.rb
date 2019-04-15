module UseCases
  module Administrator
    class GetPostcodeCoordinates
      def initialize(postcodes_gateway:)
        @postcodes_gateway = postcodes_gateway
      end

      def execute
        results = @postcodes_gateway.fetch_coordinates

        results.map { |v| [v[:latitude], v[:longitude]] }
      end
    end
  end
end
