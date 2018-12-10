class LogsController < ApplicationController
  def index
    if params[:username].present? || params[:ip].present?
      logs = UseCases::Administrator::GetAuthRequests.new(
        search_validator: UseCases::Administrator::ValidateLogSearchQuery.new,
        authentication_logs_gateway: Gateways::Sessions.new(
          ips: current_organisation.ips.map(&:address)
        )
      ).execute(
        username: params[:username]&.strip,
        ip: params[:ip]
      )

      if logs.fetch(:error).present?
        redirect_to :search_logs, alert: logs.fetch(:error)
      end

      @logs = logs.fetch(:results)
    end
  end
end
