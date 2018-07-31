class MonitoringController < ApplicationController
  def healthcheck
    render body: "Healthy"
  end
end
