class LogsController < ApplicationController
  def index
    logs = UseCases::Administrator::GetAuthRequests.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    ).execute(
      username: username,
      ip: ip
    )

    @logs = logs.fetch(:results)
  end

private

  def username
    params[:username] if params[:by] == 'username'
  end

  def ip
    params[:ip] if params[:by] == 'ip'
  end
end
