module UseCases
  module Administrator
    class CheckIfValidIp
      def execute(address)
        @address = address
        { success: valid_address? }
      end

    private

      attr_reader :address

      def valid_address?
        address.present? &&
          address_is_ipv4? &&
          !address_is_subnet? &&
          !address_allows_all? &&
          !address_is_loopback?
      end

      def address_allows_all?
        address.match?('0.0.0.0')
      end

      def address_is_subnet?
        address.include?("/")
      end

      def address_is_ipv4?
        begin
          IPAddr.new(address).ipv4?
        rescue IPAddr::InvalidAddressError
          false
        end
      end

      def address_is_loopback?
        IPAddr.new(address).loopback?
      end
    end
  end
end
