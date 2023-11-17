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
    @team = @organisation.users.order("#{sort_column} #{sort_direction}")
    @pagy, @locations = pagy(@organisation.locations.order("address asc"))
  end

  def destroy
    organisation = Organisation.find(params[:id])
    organisation.destroy!
    UseCases::Administrator::PublishOrganisationNames.new.publish
    redirect_to super_admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def sortable_columns
    %w[name created_at locations_count ips_count active_storage_attachments.created_at last_sign_in_at email sign_in_count]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    directions = %w[desc asc]
    directions.include?(params[:direction]) ? params[:direction] : directions.last
  end
end
