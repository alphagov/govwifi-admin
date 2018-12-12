class OrganisationsController < ApplicationController
  before_action :set_organisation, only: %i[edit update]
  before_action :validate_user_is_part_of_organisation, only: %i[edit update]

  def index; end

  def edit; end

  def update
    if @organisation.update(organisation_params)
      redirect_to organisation_path
      flash[:notice] = 'Organisation updated'
    else
      render :edit
    end
  end

private

  def set_organisation
    @organisation = Organisation.find(params.fetch(:id))
  end

  def validate_user_is_part_of_organisation
    unless users_belong_to_same_org
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def users_belong_to_same_org
    current_organisation == @organisation
  end

  def organisation_params
    params.require(:organisation).permit(:name, :service_email)
  end
end
