class LocationsController < ApplicationController
  def edit
    @location = Location.find(params[:id])
    @ips = []
    5.times { @ips << @location.ips.build }
  end

  def update
    @location = Location.find(params[:id])

    if @location.update(location_params)
      redirect_to ips_path, notice: "IP added to #{@location.full_address}"
    else
      @ips = @location.ips.reject{ |ip| ip.persisted? }
      render :edit
    end
  end

  def location_params
    h_version = params
      .require(:location)
      .permit(ips_attributes: [:address])
      .to_h

    {
      ips_attributes: h_version[:ips_attributes].reject do |_,a|
        a['address'].blank?
      end
    }
  end
end
