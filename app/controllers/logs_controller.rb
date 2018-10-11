class LogsController < ApplicationController
  def index
    redirect_to :search_logs, alert: generate_notice if invalid_username?

    @logs = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])
  end

private

  def generate_notice
    "Username must be 6 characters in length."
  end

  def invalid_username?
    username.nil? || username.empty? || username.length != 6
  end

  def username
    @username ||= params[:username]
  end
end
