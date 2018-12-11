class OrganisationsController < ApplicationController
  def index; end

  def edit
    @organisation = Organisation.find_by(id: params.fetch(:id))
  end

  def update
    organisation = Organisation.find_by(id: params.fetch(:id))
    if organisation.update_attributes(organisartion_params)
      flash[:notice] = 'Organisation updated'
      redirect_to organisations_path
    else
      flash[:alert] = 'Update failed'
    end
  end

private

  def organisartion_params
    params.require(:organisation).permit(:name, :service_email)
  end
end
