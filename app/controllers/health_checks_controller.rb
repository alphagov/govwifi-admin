class HealthChecksController < ApplicationController
  def index
    london_ips = ENV.fetch('LONDON_RADIUS_IPS').split(',')
    dublin_ips = ENV.fetch('DUBLIN_RADIUS_IPS').split(',')

    @health_checks = UseCases::Administrator::HealthChecks::CalculateHealth.new.execute(ips: london_ips + dublin_ips)
  end
end
