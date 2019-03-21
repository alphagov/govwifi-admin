class Admin::OrganisationsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @organisations = Organisation
      .includes(:signed_mou_attachment)
      .order("#{sort_column} #{sort_direction}")

    @location_count = Location.count
  end

  def show
    @organisation = Organisation.find(params[:id])
    @locations = @organisation.locations.order("#{sort_column_show} #{sort_direction_show}")
  end

  def destroy
    organisation = Organisation.find(params[:id])
    organisation.destroy
    redirect_to admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def sortable_columns
    %w[name created_at active_storage_attachments.created_at address]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_column_show
    sortable_columns.include?(params[:sort]) ? params[:sort] : sortable_columns.last
  end

  def sort_direction
    directions = %w[asc desc]
    directions.include?(params[:direction]) ? params[:direction] : directions.last
  end

  def sort_direction_show
    direction = %w[asc]
    direction.include?(params[:direction]) ? params[:direction] : direction.first
  end
end
