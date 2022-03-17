class LogsSearchesController < ApplicationController
  skip_before_action :redirect_user_with_no_organisation
  def create
    @search = LogsSearch.new(search_params)
    @locations = ordered_locations

    @search.first_step ? filter_choice : term_choice
  end

  def filter_choice
    if @search.filter.present?
      render @search.filter
    else
      @search.errors.add(:filter, "can't be blank")
      render "new"
    end
  end

  def term_choice
    if @search.valid?
      redirect_to logs_path(@search.filter.to_sym => @search.search_term)
    else
      render @search.filter
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

  def search_params
    params.require(:logs_search)
      .permit(:filter, :first_step, :search_term)
      .each { |_, v| v.strip! }
  end

  def ordered_locations
    current_organisation.nil? ? [] : current_organisation.locations.order([:address])
  end
end
