class LogsSearchesController < ApplicationController
  skip_before_action :redirect_user_with_no_organisation

  def new
    log_search_form = LogSearchForm.new
    render locals: { log_search_form: }
  end

  def choose_option
    log_search_form = LogSearchForm.new(search_form_params[:log_search_form])
    if log_search_form.valid?
      render log_search_form.view_to_render
    else
      render "new"
    end
  end

private

  def search_form_params
    params[:log_search_form].transform_values(&:strip)
  end
end
