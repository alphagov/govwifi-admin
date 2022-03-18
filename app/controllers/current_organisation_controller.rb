class CurrentOrganisationController < ApplicationController
  skip_before_action :redirect_user_with_no_organisation

  def edit; end

  def update
    session[:organisation_id] = params[:organisation_id]
    redirect_to root_path
  end

protected

  def sidebar
    :empty
  end
end
