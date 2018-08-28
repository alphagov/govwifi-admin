module UseCases
  module Administrator
    module HealthChecks
      class CalculateHealth
        def initialize(route53_gateway: Gateways::Route53.new, health_checks_fetcher:)
          @route53_gateway = route53_gateway
          @health_checks_fetcher = health_checks_fetcher
        end

        def execute
          health_checks_fetcher.execute.map do |health_check_ip_and_id|
            ip = health_check_ip_and_id.fetch(:ip_address)
            id = health_check_ip_and_id.fetch(:id)

            {
              ip: ip,
              status: status(route53_gateway.get_health_check_status(health_check_id: id))
            }
          end
        end

      private

        SUCCESS_STATUS = 'Success: HTTP Status Code 200, OK'.freeze

        def status(health_check)
          all_health_checkers_healthy?(health_check) ? :healthy : :unhealthy
        end

        def all_health_checkers_healthy?(health_check)
          health_check.health_check_observations.all? do |a|
            a.status_report.status == SUCCESS_STATUS
          end
        end

        attr_reader :health_checks_fetcher, :route53_gateway
      end
    end
  end
end
