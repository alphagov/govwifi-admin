class HomeController < ApplicationController
  def index
    redirect_to admin_organisations_path if current_user.super_admin?
    @ips = current_organisation.ips
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

private

  def radius_ips
    view_radius = UseCases::Organisation::ViewRadiusIPAddresses.new(organisation_id: current_organisation.id)
    view_radius.execute
  end
end
