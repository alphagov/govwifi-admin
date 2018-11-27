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
          strip_whitespace &&
          !(address_is_subnet? || address_allows_all?)
      end

      def address_allows_all?
        address.match?('0.0.0.0')
      end

      def strip_whitespace
        address.strip unless address.nil?
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
    end
  end
end
