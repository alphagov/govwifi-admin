class LocationsController < ApplicationController
  def new
    @location = Location.new
    add_blank_ips!
  end

  def create
    @location = Location.create(location_params_without_blank_ips)

    if @location.save
      Facades::Ips::AfterCreate.new.execute
      redirect_to ips_path, notice: "#{@location.full_address} added"
    else
      add_blank_ips!
      render :new
    end
  end

private

  def add_blank_ips!
    desired_count = 5
    desired_count = desired_count - @location.ips.length
    desired_count.times { @location.ips.build }
  end

  def location_params_without_blank_ips
    location_params = params
      .require(:location)
      .permit(ips_attributes: [:address])

    present_ips = location_params[:ips_attributes].reject do |_, a|
      a['address'].blank?
    end

    {
      address: params.dig(:location, :address),
      postcode: params.dig(:location, :postcode),
      organisation_id: current_organisation.id,
      ips_attributes: present_ips
    }
  end
end
