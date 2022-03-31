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

  def create
    @search = LogsSearch.new(search_params)
    @locations = ordered_locations
    term_choice
  end

  def filter_choice
    if @search.filter.present?
      render @search.render
    else
      @search.errors.add(:filter, "can't be blank")
      render "new"
    end
  end

  def term_choice
    if @search.valid?
      redirect_to logs_path(@search.filter.to_sym => @search.search_term)
    else
      render @search.render
    end
  end

  def ip
    @search = LogsSearch.new(filter: "ip")
  end

  def username
    @search = LogsSearch.new(filter: "username")
  end

  def location
    @search = LogsSearch.new(filter: "location")
    @locations = ordered_locations
  end

private

  def search_form_params
    params[:log_search_form].transform_values(&:strip)
  end

  def search_params
    params.require(:logs_search)
          .permit(:filter, :first_step, :search_term)
          .each { |_, v| v.strip! }
  end
end
