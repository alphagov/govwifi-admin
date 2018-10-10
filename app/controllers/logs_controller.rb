class LogsController < ApplicationController
  def index
    @logs = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])

    # @raw_logs.filter{|log| log is from an ip that is in the current_organisation.ips array}
  end
end
