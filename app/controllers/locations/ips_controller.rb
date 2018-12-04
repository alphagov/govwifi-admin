class Locations::IpsController < ApplicationController
  before_action :set_location

  def new
    @ip = @location.ips.new
  end

  def create
    ips = ips_from_params.each{|ip| ip.save}

    if ips.all?(&:valid?)
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

  def ips_from_params
    addresses = params.dig(:ip, :address) || []
    addresses.map do |address|
      Ip.new(address: address, location: @location)
    end
  end
end
