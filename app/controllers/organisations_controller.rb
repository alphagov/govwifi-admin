class OrganisationsController < ApplicationController
  def index; end

  def edit
    @organisation = Organisation.find_by(id: params.fetch(:id))
  end

  def update
    # @user.permission.update!(permission_params[:permission_attributes])

    flash[:notice] = 'Organisation updated'
    redirect_to organisations_path
  end
end
