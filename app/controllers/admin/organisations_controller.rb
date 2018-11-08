class Admin::OrganisationsController < AdminController
  def index
    @organisations = Organisation.order(:name).all
  end

  def show
    organisation_id = params[:id]
    @organisation = Organisation.find(organisation_id)
  end
end
