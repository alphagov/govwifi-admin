class LogsController < ApplicationController
  def index
    auth_requests = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])

    @logs = filter_auth_requests(auth_requests)
  end

  def filter_auth_requests(auth_requests)
    ips = current_organisation.ips.map(&:address)
    auth_requests.select { |auth_request| ips.include? (auth_request["siteIP"]) }
  end
end
