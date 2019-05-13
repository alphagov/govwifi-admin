class Admin::OrganisationsController < AdminController
  helper_method :sort_column, :sort_direction
  CSV_HEADER = "email address".freeze

  def index
    @organisations = Organisation
      .includes(:signed_mou_attachment)
      .order("#{sort_column} #{sort_direction}")

    @location_count = Location.count

    respond_to do |format|
      format.html
      format.csv { send_data service_emails_csv, filename: "service_emails.csv" }
    end
  end

  def show
    @organisation = Organisation.find(params[:id])
    @team = sorted_team_members(@organisation)
    @locations = @organisation.locations.order("address asc")
  end

  def destroy
    organisation = Organisation.find(params[:id])
    organisation.destroy
    publish_organisation_names
    redirect_to admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def service_emails_csv
    service_emails = Organisation.pluck(:service_email)
    service_emails.prepend(CSV_HEADER).join("\n")
  end

  def sorted_team_members(organisation)
    UseCases::Administrator::SortUsers.new(
      users_gateway: Gateways::OrganisationUsers.new(organisation: organisation)
    ).execute
  end

  def publish_organisation_names
    UseCases::Administrator::PublishOrganisationNames.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_PRODUCT_PAGE_DATA_BUCKET'),
        key: ENV.fetch('S3_ORGANISATION_NAMES_OBJECT_KEY')
      ),
      source_gateway: Gateways::OrganisationNames.new,
      presenter: UseCases::Administrator::FormatOrganisationNames.new
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
