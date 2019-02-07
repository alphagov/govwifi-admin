class Admin::CustomOrganisationsController < AdminController

  def index
    @number_of_custom_orgs = CustomOrganisationName.count
  end

  def create
    # Add whatever is in that text field into the database
    add_custom_organiastion = CustomOrganisationName.create(params[:name])

    flash[:notice] = 'Successfully added a custom organisation'
    redirect_to root_path
  end
end
