module UseCases
  module Administrator
    class CheckIfValidLocationAddress
      def execute(address)
        { success: is_location_address_valid?(address) }
      end

    private

      def is_location_address_valid?(address)
        return false if address == ''
        return false if address.nil?
        true
      end
    end
  end
end
