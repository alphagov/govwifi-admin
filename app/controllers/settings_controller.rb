class SettingsController < ApplicationController
  def index
    @ips = current_organisation.ips
    @locations = current_organisation.locations
    @team_members = current_organisation.users
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

private

  def radius_ips
    view_radius = UseCases::Organisation::ViewRadiusIpAddresses.new(organisation_id: current_organisation.id)
    view_radius.execute
  end
end
