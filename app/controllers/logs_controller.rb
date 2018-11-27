class LogsController < ApplicationController
  def index
    if params[:username].present? || params[:ip].present?
      logs = UseCases::Administrator::GetAuthRequests.new(
        search_validator: UseCases::Administrator::ValidateLogSearchQuery.new,
        authentication_logs_gateway: Gateways::Sessions.new(
          ips: current_organisation.ips.map(&:address)
        )
      ).execute(
        username: strip_username_trailing_whitespace,
        ip: strip_ip_trailing_whitespace
      )

      if logs.fetch(:error).present?
        redirect_to :search_logs, alert: logs.fetch(:error)
      end

      @logs = logs.fetch(:results)
    end
  end

  def strip_username_trailing_whitespace
    params[:username].strip unless params[:username].nil?
  end

  def strip_ip_trailing_whitespace
    params[:ip].strip unless params[:ip].nil?
  end
end
