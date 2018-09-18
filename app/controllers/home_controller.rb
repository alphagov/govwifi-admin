class HomeController < ApplicationController
  def index
    @ips = current_organisation.ips
    @name = current_organisation.name
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

private

  def radius_ips
    ViewRadiusIPAddresses.new.execute
  end
end
