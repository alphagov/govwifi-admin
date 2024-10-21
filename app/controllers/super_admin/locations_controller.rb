class SuperAdmin::LocationsController < ApplicationController
  include SuperUserConcern

  def index
    @locations = Location.order("#{sort_column} #{sort_direction}").includes(:organisation)
  end

private

  def sortable_columns
    %w[address]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "address"
  end

  def sort_direction
    directions = %w[asc]
    directions.include?(params[:direction]) ? params[:direction] : directions.first
  end
end
