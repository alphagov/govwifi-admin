module UseCases
  module Administrator
    module HealthChecks
      class CalculateHealth
        def initialize(route53_gateway: Gateways::Route53.new)
          @route53_gateway = route53_gateway
        end

        def execute(ips:)
          ips.map { |ip| status_for_ip(ip) }.compact
        end

      private

        attr_reader :fetch_health_checks_use_case, :route53_gateway

        SUCCESS_STATUS = 'Success: HTTP Status Code 200, OK'.freeze

        def status_for_ip(ip)
          health_check = health_check_for_ip(ip)

          return if health_check.nil?

          {
            ip_address: health_check.health_check_config.ip_address,
            status: status(route53_gateway.get_health_check_status(health_check_id: health_check.id))
          }
        end

        def health_check_for_ip(ip)
          health_checks.find do |health_check|
            health_check.health_check_config.ip_address == ip
          end
        end

        def status(health_check)
          all_health_checkers_healthy?(health_check) ? :operational : :offline
        end

        def all_health_checkers_healthy?(health_check)
          health_check.health_check_observations.all? do |a|
            a.status_report.status == SUCCESS_STATUS
          end
        end

        def health_checks
          @health_checks ||= route53_gateway.list_health_checks.health_checks
        end
      end
    end
  end
end
