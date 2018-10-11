class LogsController < ApplicationController
  def index
    auth_requests = UseCases::Administrator::GetAuthRequestsForUsername.new(
      authentication_logs_gateway: Gateways::LoggingApi.new
    ).execute(username: params[:username])

    ips = current_organisation.ips.map(&:address)
    @logs = auth_requests.select { |auth_request| ips.include? (auth_request["siteIP"]) }
  end
end
