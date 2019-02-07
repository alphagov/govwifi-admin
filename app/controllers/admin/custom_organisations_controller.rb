class Admin::CustomOrganisationsController < AdminController
  def index
    all_custom_organisation_names
  end

  def create
    all_custom_organisation_names
    created_org = CustomOrganisationName.create(custom_org_params)

    if created_org.valid?
      flash[:notice] = 'Successfully added a custom organisation'
      redirect_to root_path
    else
      flash[:alert] = "Organisation name can't be blank"
      render :index
    end
  end

private

  def all_custom_organisation_names
    @all_orgs = CustomOrganisationName.all
  end

  def custom_org_params
    params.require(:custom_organisations).permit(:name)
  end
end
