class StatusController < ApplicationController
  def index
    london_ips = ENV.fetch("LONDON_RADIUS_IPS").split(",")
    dublin_ips = ENV.fetch("DUBLIN_RADIUS_IPS").split(",")

    health_checks = UseCases::Administrator::HealthChecks::CalculateHealth.new.execute(ips: london_ips + dublin_ips)

    @health_checks_dublin = health_checks.select { |h| dublin_ips.include?(h.fetch(:ip_address)) }
    @health_checks_london = health_checks.select { |h| london_ips.include?(h.fetch(:ip_address)) }
  end
end
