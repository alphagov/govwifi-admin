class LogsController < ApplicationController
  def index
    use_case = UseCases::Administrator::GetAuthRequests.new(
      authentication_logs_gateway: Gateways::Sessions.new(
        ips: current_organisation.ips.map(&:address)
      )
    )

    if params[:ip].present?
      logs = use_case.execute(ips: [params[:ip]])
    elsif params[:username].present?
      logs = use_case.execute(username: params[:username])
    elsif params[:location].present?
      # TODO: don't allow locations outside the org
      location = Location.find(params[:location])

      if location.organisation == current_organisation
        @location_name = location.address
        logs = use_case.execute(ips: location.ips.map(&:address))
      else
        redirect_to location_new_logs_search_path and return
      end
    else
      redirect_to new_logs_search_path and return
    end

    @logs = logs.fetch(:results)
  end
end
