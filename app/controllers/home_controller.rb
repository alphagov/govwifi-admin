class HomeController < ApplicationController
  def index
    return redirect_to admin_organisations_path if current_user.super_admin?

    redirect_to setup_instructions_path unless current_organisation.ips.present? || request.path == '/overview'

    @ips = current_organisation.ips
    @locations = current_organisation.locations
    @team_members = current_organisation.users
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

private

  def radius_ips
    view_radius = UseCases::Organisation::ViewRadiusIPAddresses.new(organisation_id: current_organisation.id)
    view_radius.execute
  end
end
