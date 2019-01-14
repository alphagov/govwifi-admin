class LogsController < ApplicationController
  def index
    if valid_search_params.blank?
      redirect_to(new_logs_search_path) && return
    end

    if params[:location].present?
      location = current_organisation.locations.find(params[:location])
      location_ips = location.ips.map(&:address)
      @location_address = location.address
    end

    @logs = get_auth_requests.execute(
      ips: location_ips || params[:ip],
      username: params[:username]
    ).fetch(:results)
  end

private

  def valid_search_params
    params.keys & %w[ip username location]
  end

  def get_auth_requests
    UseCases::Administrator::GetAuthRequests.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    )
  end
end
