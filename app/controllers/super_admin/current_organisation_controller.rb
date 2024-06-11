class SuperAdmin::CurrentOrganisationController < SuperAdminController
  def edit; end

  def update
    session[:organisation_id] = params[:organisation_id]
    redirect_to root_path
  end
end
