class Admin::OrganisationsController < AdminController
  def index
    @organisations = Organisation.order(:name).all
  end
end
