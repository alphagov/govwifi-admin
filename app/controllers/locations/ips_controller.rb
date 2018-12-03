class Locations::IpsController < ApplicationController
  before_action :set_location

  def new
    @ip = @location.ips.new
  end

  def create
    @ip = @location.ips.new(ip_params)

    if @ip.save
      Services::HandleNewIp.new(ip: @ip).execute
      redirect_to(
        ips_path,
        notice: "#{@ip.address} added, it will be active starting tomorrow"
      )
    else
      render :new
    end
  end

private

  def set_location
    @location = current_organisation
      .locations
      .find_by(id: params[:location_id])
  end

  def ip_params
    params.require(:ip).permit(:address)
  end
end
