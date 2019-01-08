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

    # TODO: don't allow locations outside the org
    @location = Location.find(params[:location]).address
  end
end
