module UseCases
  module Administrator
    class ConvertPostcode
      def initialize(convert_postcode_gateway:, postcode: )
        @convert_postcode_gateway = convert_postcode_gateway
        @postcode = postcode
      end

      def execute
        convert_postcode_gateway.fetch_coordinates(postcode)
      end

    private

      attr_reader :convert_postcode_gateway
      attr_reader :postcode
    end
  end
end
