class Admin::CustomOrganisationsController < AdminController

  def index; end

  def create
    CustomOrganisationName.create(custom_org_params)

    flash[:notice] = 'Successfully added a custom organisation'
    redirect_to root_path
  end

private

  def custom_org_params
    params.require(:custom_organisations).permit(:name)
  end
end
