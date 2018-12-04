class Locations::IpsController < ApplicationController
  before_action :set_location

  def new
    @ip = @location.ips.new
  end

  def create
    if ips.all?(&:valid?)
      ips.each{|ip| ip.save}

      Facades::Ips::AfterCreate.new.execute
      redirect_to(
        ips_path,
        notice: "Ips added"
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

  def ips
    params.dig(:ip, :address).map do |address|
      Ip.new(address: address, location: @location)
    end
  end
end
