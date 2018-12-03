class Locations::IpsController < ApplicationController
  def new
    @location = current_organisation.locations.find_by(id: params[:location_id])
    @ip = @location.ips.new
  end
end
