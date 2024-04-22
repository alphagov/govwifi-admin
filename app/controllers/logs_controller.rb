class LogsController < ApplicationController
  skip_before_action :redirect_user_with_no_organisation

  def index
    log_search_form = LogSearchForm.new(form_params)
    return render "logs_searches/new", locals: { log_search_form: } unless log_search_form.valid?

    success = log_search_form.success
    authentication_method = log_search_form.authentication_method

    case log_search_form.filter_option
    when LogSearchForm::LOCATION_FILTER_OPTION
      location = current_organisation.locations.find(log_search_form.location_id)
      logs = Gateways::Sessions.search(ips: location.ips.pluck(:address), success:)
      render locals: { log_search_form:, location_address: location.address, logs: }
    when LogSearchForm::IP_FILTER_OPTION
      ips = if super_admin?
              log_search_form.ip
            else
              current_organisation.ip_addresses.intersection([log_search_form.ip])
            end
      logs = Gateways::Sessions.search(ips:, success:)
      set_authentication_method(logs) if logs.present?
      logs = Gateways::Sessions.search(ips:, success:, authentication_method:)

      @current_location = Ip.find_by(address: ips).location if logs.present?
      render locals: { log_search_form:, logs: }
    when LogSearchForm::USERNAME_FILTER_OPTION
      ips = super_admin? ? nil : current_organisation.ip_addresses
      logs = Gateways::Sessions.search(ips:, username: log_search_form.username, success:)
      render locals: { log_search_form:, logs: }
    end
  end

private

  def form_params
    params.require(:log_search_form)
      .permit(:filter_option, :ip, :username, :location_id, :success, :authentication_method)
      .transform_values(&:strip)
  rescue StandardError
    {}
  end

  def set_authentication_method(logs)
    logs.each(&:set_authentication_method)
  end
end
