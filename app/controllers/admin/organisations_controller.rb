class Admin::OrganisationsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @organisations = Organisation
      .includes(:signed_mou_attachment)
      .order("#{sort_column} #{sort_direction}")

    @location_count = Location.count
  end

  def show
    @organisation = Organisation.find_by(id: params[:id]) || Organisation.find_by(uuid: params[:id])
    @team = sorted_team_members(@organisation)
    @locations = @organisation.locations.order("address asc")
  end

  def destroy
    organisation = Organisation.find_by(id: params[:id]) || Organisation.find_by(uuid: params[:id])
    organisation.destroy
    redirect_to admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation: organisation)
    ).execute
  end

  def sortable_columns
    %w[name created_at active_storage_attachments.created_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    directions = %w[desc asc]
    directions.include?(params[:direction]) ? params[:direction] : directions.first
  end
end
