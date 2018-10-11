class LogsController < ApplicationController
  def index
    redirect_to :search_logs, alert: alert if invalid_username?

    results = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])

    @logs = sort_results_by_most_recent(results)
  end

private

  def alert
    "Username must be 6 characters in length."
  end

  def invalid_username?
    username.nil? || username.empty? || username.length != 6
  end

  def username
    @username ||= params[:username]
  end

  def sort_results_by_most_recent(results)
    results.sort_by { |log| log["start"] }.reverse
  end
end
