class MonitoringController < ApplicationController
  skip_before_action :authenticate_user!

  def healthcheck
    render body: "Healthy"
  end
end
