class MonitoringController < ApplicationController
  skip_before_action :authenticate_user!

  def healthcheck
    NotifyTemplates.verify_templates
    render body: "Healthy"
  end
end
