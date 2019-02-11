class Admin::OrganisationsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    @organisations = Organisation.includes(:signed_mou_attachment).order("#{sort_column} #{sort_direction}").all
  end

  def show
    @organisation = Organisation.find(params[:id])
    @unique_connections = UseCases::Administrator::GetRecentUniqueUserRequests.new(
      authentication_logs_gateway: Gateways::UniqueConnections.new(
        ips: @organisation.ips.map(&:address)
      )
    ).execute.fetch(:connection_count)
  end

  def destroy
    organisation = Organisation.find(params[:id])
    organisation.destroy
    redirect_to admin_organisations_path, notice: "Organisation has been removed"
  end

private

  def sortable_columns
    %w[name created_at active_storage_attachments.created_at]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
