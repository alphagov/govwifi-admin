class OrganisationsController < ApplicationController
  before_action :index, :authorise_admin

  def index
    @all_organisations = Organisation.all
  end

private

  def authorise_admin
    redirect_to root_path unless current_user.admin?
  end
end
