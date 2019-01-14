class LogsController < ApplicationController
  def index
    if valid_search_params.blank?
      redirect_to(new_logs_search_path) && return
    end

    if params[:location].present?
      location = current_organisation.locations.find(params[:location])
      @location_name = location.address
    end

    use_case = UseCases::Administrator::GetAuthRequests.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    )

    @logs = use_case
      .execute(ips: ip_params, username: params[:username])
      .fetch(:results)
  end

private

  def valid_search_params
    params.keys & %w[ip username location]
  end

  def ip_params
    if params[:location].present?
      Location.find(params[:location]).ips.map(&:address)
    else
      params[:ip] ? [params[:ip]] : nil
    end
  end
end
