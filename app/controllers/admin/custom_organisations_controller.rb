class Admin::CustomOrganisationsController < AdminController
  helper_method :sort_column, :sort_direction

  def index
    order_custom_orgs
    @custom_organisation = CustomOrganisationName.new
  end

  def create
    @custom_organisation_names = ordered_custom_orgs
    @custom_organisation = CustomOrganisationName.new(custom_org_params)

    if @custom_organisation.save
      flash.now[:notice] = "Custom organisation has been successfully added"
    end
    render :index
  end

  def destroy
    custom_org = CustomOrganisationName.find(params.fetch(:id))

    if custom_org.destroy
      notice = "Successfully removed #{custom_org.name}"
    else
      redirect_to admin_custom_organisations_path, notice: custom_org.errors.full_messages
    end
    redirect_to admin_custom_organisations_path, notice: notice
  end

private

  def custom_org_params
    params.require(:custom_organisations).permit(:name)
  end

  def order_custom_orgs
    @custom_organisation_names = CustomOrganisationName.all.order("#{sort_column} #{sort_direction}")
  end

  def sortable_columns
    %w[name]
  end

  def sortable_directions
    %w[asc]
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : sortable_columns.first
  end

  def sort_direction
    sortable_directions.include?(params[:direction]) ? params[:direction] : sortable_directions.first
  end
end
