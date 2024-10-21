class SuperAdmin::CurrentOrganisationController < ApplicationController
  include SuperUserConcern

  def edit; end

  def update
    session[:organisation_id] = params[:organisation_id]
    redirect_to root_path
  end
end
