class Admin::CustomOrganisationsController < AdminController
  def index
    @all_orgs = CustomOrganisationName.all
    @custom_organisation = CustomOrganisationName.new
  end

  def create
    @all_orgs = CustomOrganisationName.all
    @custom_organisation = CustomOrganisationName.new(custom_org_params)

    if @custom_organisation.save
      flash[:notice] = "Custom organisation has been successfully added"
    end
    render :index
  end

private

  def custom_org_params
    params.require(:custom_organisations).permit(:name)
  end
end
