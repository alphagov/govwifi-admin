module UseCases
  module Administrator
    module HealthChecks
      class Fetcher
        def initialize(route53_gateway: Gateways::Route53.new, ips:)
          @route53_gateway = route53_gateway
          @ips = ips
        end

        def execute
          result = route53_gateway.list_health_checks.health_checks

          with_ips(ips, without_latency_health_checks(result)).compact
        end

      private

        attr_reader :route53_gateway, :ips

        def with_ips(ips, health_checks)
          health_checks.map do |health_check|
            if ips.include?(health_check.health_check_config.ip_address)
              {
                ip_address: health_check.health_check_config.ip_address,
                id: health_check.id
              }
            end
          end
        end

        def without_latency_health_checks(health_checks)
          health_checks.reject do |hc|
            hc.health_check_config.measure_latency == true
          end
        end
      end
    end
  end
end
