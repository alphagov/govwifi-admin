class LogsController < ApplicationController
  def index
    logs = UseCases::Administrator::GetAuthRequests.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    ).execute(
      username: params[:username],
      ip: params[:ip]
    )

    @logs = logs.fetch(:results)
  end
end
