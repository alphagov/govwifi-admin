class LogsController < ApplicationController
  def index
    if location_outside_organisation?
      redirect_to(location_new_logs_search_path) && return
    end

    if valid_search_params.blank?
      redirect_to(new_logs_search_path) && return
    end

    @location_name = Location.find_by(id: params[:location])&.address

    @logs = get_auth_requests
      .execute(ips: ip_params, username: params[:username])
      .fetch(:results)
  end

private

  def location_outside_organisation?
    return unless params[:location].present?

    location = Location.find(params[:location])
    location.organisation != current_organisation
  end

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

  def ip_params
    if params[:location].present?
      Location.find(params[:location]).ips.map(&:address)
    else
      params[:ip] ? [params[:ip]] : nil
    end
  end
end
