class Admin::AddUserToOrganisationController < AdminController
  def index
    organisation_id = params[:organisation_id]
    @organisation = Organisation.find(organisation_id)
  end
end
