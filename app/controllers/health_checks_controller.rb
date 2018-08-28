class HealthChecksController < ApplicationController
  def index
    london_ips = ENV.fetch('LONDON_RADIUS_IPS').split(',')
    dublin_ips = ENV.fetch('DUBLIN_RADIUS_IPS').split(',')

    health_checks_fetcher_use_case = UseCases::Administrator::HealthChecks::Fetcher.new(ips: london_ips + dublin_ips)

    @health_checks = UseCases::Administrator::HealthChecks::CalculateHealth.new(
      health_checks_fetcher: health_checks_fetcher_use_case
    ).execute
  end
end
