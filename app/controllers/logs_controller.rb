class LogsController < ApplicationController
  def index
    logs = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    ).execute(username: params.fetch(:username))

    if logs.fetch(:error).present?
      redirect_to :search_logs, alert: logs.fetch(:error)
    end

    @logs = logs.fetch(:results)
  end
end
