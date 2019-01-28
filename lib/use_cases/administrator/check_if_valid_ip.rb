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
          address_is_not_subnet? &&
          address_does_not_allows_all? &&
          address_is_not_loopback? &&
          address_is_not_private?
      end

      def address_does_not_allows_all?
        !address.match?('0.0.0.0')
      end

      def address_is_not_subnet?
        !address.include?("/")
      end

      def address_is_ipv4?
        begin
          IPAddr.new(address).ipv4?
        rescue IPAddr::InvalidAddressError
          false
        end
      end

      def address_is_not_loopback?
        !IPAddr.new(address).loopback?
      end

      def address_is_not_private?
        !IPAddr.new(address).private?
      end

    end
  end
end
