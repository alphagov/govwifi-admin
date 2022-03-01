class SuperAdmin::OrganisationsController < SuperAdminController
  helper_method :sort_column, :sort_direction

  def index
    @organisations = Organisation.sortable_with_child_counts(sort_column, sort_direction)

    @location_count = Location.count

    respond_to do |format|
      format.html
      format.csv { send_data Organisation.all_as_csv, filename: "organisations.csv" }
    end
  end

  def service_emails
    respond_to do |format|
      format.csv { send_data Organisation.service_emails_as_csv, filename: "service_emails.csv" }
    end
  end

  def show
    @organisation = Organisation.find(params[:id])
    @team = sorted_team_members(@organisation)
    @pagy, @locations = pagy(@organisation.locations.order("address asc"))
  end

  def destroy
    organisation = Organisation.find(params[:id])
    organisation.destroy!
    publish_organisation_names
    redirect_to super_admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation:),
    ).execute
  end

  def publish_organisation_names
    UseCases::Administrator::PublishOrganisationNames.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch("S3_PRODUCT_PAGE_DATA_BUCKET"),
        key: ENV.fetch("S3_ORGANISATION_NAMES_OBJECT_KEY"),
      ),
      source_gateway: Gateways::OrganisationNames.new,
      presenter: UseCases::Administrator::FormatOrganisationNames.new,
    ).execute
  end

  def sortable_columns
    %w[name created_at locations_count ips_count active_storage_attachments.created_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    directions = %w[desc asc]
    directions.include?(params[:direction]) ? params[:direction] : directions.first
  end
end
