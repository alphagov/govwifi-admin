class CurrentOrganisationController < ApplicationController
  def edit
    @organisation_specific = false
  end

  def update
    session[:organisation_id] = params[:organisation_id]
    redirect_to root_path
  end
end
