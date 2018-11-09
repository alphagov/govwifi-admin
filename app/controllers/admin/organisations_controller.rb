class OrganisationsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :index, :authorise_admin

  def index
    @organisations = Organisation.order("#{sort_column} #{sort_direction}").all
  end

private

  def authorise_admin
    redirect_to root_path unless current_user.admin?
  end

  def sortable_columns
    %w[name created_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
