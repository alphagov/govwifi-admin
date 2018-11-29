class Locations::IpsController < ApplicationController
  def new
    @location = current_organisation.locations.find_by(id: params[:location_id])
    @ip = @location.ips.new
  end

  def create
    ip.create(params[:ip])

    @ip = Ip.new(create_params)

    if @ip.save
      publish_for_performance_platform
      publish_radius_whitelist
      redirect_to(
        ips_path,
        anchor: 'ips',
        notice: "#{@ip.address} added, it will be active starting tomorrow"
      )
    else
      @locations = available_locations
      render :new
    end
  end
end
