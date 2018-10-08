class LogsController < ApplicationController
  def index
    @logs = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])
  end
end
