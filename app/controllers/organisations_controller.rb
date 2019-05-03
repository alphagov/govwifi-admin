class OrganisationsController < ApplicationController
  before_action :set_organisation, only: %i[edit update]
  before_action :validate_user_is_part_of_organisation, only: %i[edit update]

  def edit; end

  def update
    if @organisation.update(organisation_params)
      redirect_to team_members_path
      flash[:notice] = 'Service email updated'
    else
      render :edit
    end
  end

private

  def set_organisation
    @organisation = Organisation.find_by(id: params[:id]) || Organisation.find_by(uuid: params[:id])
  end

  def validate_user_is_part_of_organisation
    unless user_belongs_to_same_org
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def user_belongs_to_same_org
    current_organisation == @organisation
  end

  def organisation_params
    params.require(:organisation).permit(:service_email)
  end
end
