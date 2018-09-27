class HomeController < ApplicationController
  def index
    @ips = current_organisation.ips
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

private

  def radius_ips
    view_radius = ViewRadiusIPAddresses.new(organisation_id: current_organisation.id)
    view_radius.execute
  end
end
