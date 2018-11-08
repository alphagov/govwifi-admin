class Admin::OrganisationsController < AdminController
  def index
    @organisations = Organisation.order(:name).all
  end

  def show
    @organisation = Organisation.find(params[:id])
  end
end
