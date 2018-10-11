class LogsController < ApplicationController
  def index
    redirect_to :search_logs, alert: alert if invalid_username?

    auth_requests = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: username)

    @logs = sort_and_filter_results(auth_requests)
  end

private

  def sort_and_filter_results(auth_requests)
    filtered = filter_auth_requests(auth_requests)
    sort_results_by_most_recent(filtered)
  end

  def filter_auth_requests(auth_requests)
    ips = current_organisation.ips.map(&:address)
    auth_requests.select { |auth_request| ips.include? (auth_request["siteIP"]) }
  end

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
