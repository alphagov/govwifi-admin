module UseCases
  module Organisation
    class ViewRadiusIPAddresses
      def initialize(organisation_id:)
        @organisation_id = organisation_id
      end

      def execute
        validate_as_ip_addresses!(london_ips)
        validate_as_ip_addresses!(dublin_ips)

        { london: london_ips, dublin: dublin_ips }
      end

    private

      def order_by_organisation(ip_array)
        srand @organisation_id
        ip_array.shuffle
      end

      def london_ips
        ips = ENV.fetch('LONDON_RADIUS_IPS').split(',')
        order_by_organisation(ips)
      end

      def dublin_ips
        ips = ENV.fetch('DUBLIN_RADIUS_IPS').split(',')
        order_by_organisation(ips)
      end

      def validate_as_ip_addresses!(addresses)
        addresses.each { |address| IPAddr.new(address) }
      end
    end
  end
end
