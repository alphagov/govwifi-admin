class LocationsController < ApplicationController
  def new
    @location = Location.new
    add_blank_ips!
  end

  def create
    @location = Location.create(location_params)

    if @location.save
      # Facades::Ips::AfterCreate.new.execute
      redirect_to ips_path, notice: "#{@location.full_address} added"
    else
      add_blank_ips!
      render :new
    end
  end

  private

  def add_blank_ips!
    desired_count = 6
    desired_count = desired_count - @location.ips.length
    desired_count.times { @location.ips.build }
  end

  def location_params
    ips = params.require(:location)
      .permit(:address, :postcode, ips_attributes: [:address])

    ips = ips.to_h[:ips_attributes]
    present_ips = ips.reject{ |_,a| a['address'].blank? }

    {
      address: params[:location][:address],
      postcode: params[:location][:postcode],
      organisation_id: current_organisation.id,
      ips_attributes: present_ips
    }
  end
end
