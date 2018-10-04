class LogsController < ApplicationController
  def index
    result = UseCases::Administrator::GetLogsForUsername.new(
      gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])

    @logs = result
  end
end
