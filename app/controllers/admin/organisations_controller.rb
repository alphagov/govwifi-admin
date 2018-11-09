class Admin::OrganisationsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @organisations = Organisation.order("#{sort_column} #{sort_direction}").all
  end

  def show
    @organisation = Organisation.find(params[:id])
  end

private

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
