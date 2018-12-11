class OrganisationsController < ApplicationController
  def index; end

  def edit
    @organisation = Organisation.find_by(id: params.fetch(:id))
  end

  def update
    @organisation = Organisation.find_by(id: params.fetch(:id))

    if @organisation.update(organisation_params)
      redirect_to organisation_path
      flash[:notice] = 'Organisation updated'
    else
      render :edit
    end
  end

private

  def organisation_params
    params.require(:organisation).permit(:name, :service_email)
  end
end
