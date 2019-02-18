class Admin::CustomOrganisationsController < AdminController
  def index
    @custom_organisation_names = CustomOrganisationName.all
    @custom_organisation = CustomOrganisationName.new
  end

  def create
    @custom_organisation_names = CustomOrganisationName.all
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
      notice = custom_org.errors.full_messages
    end

    redirect_to admin_custom_organisations_path, notice: notice
  end

private

  def custom_org_params
    params.require(:custom_organisations).permit(:name)
  end
end
