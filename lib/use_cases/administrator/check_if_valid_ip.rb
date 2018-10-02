module UseCases
  module Administrator
    class CheckIfValidIp
      def execute(address)
        { success: address_valid_for_radius?(address) }
      end

    private

      def address_valid_for_radius?(address)
        return false if invalid_address?(address)
        address_is_ipv4?(address)
      end

      def invalid_address?(address)
        address.nil? || address_is_subnet?(address) || allow_all?(address)
      end

      def allow_all?(address)
        address.match?('0.0.0.0')
      end

      def address_is_subnet?(address)
        address.include?("/")
      end

      def address_is_ipv4?(address)
        begin
          IPAddr.new(address).ipv4?
        rescue IPAddr::InvalidAddressError
          false
        end
      end
    end
  end
end
