class LocationsController < ApplicationController
  def edit
    @location = Location.find(params[:id])
    @ips = []
    5.times { @ips << @location.ips.build }
  end

  def update
    @location = Location.find(params[:id])

    if @location.update(location_params)
      redirect_to ips_path
    else
      @ips = @location.ips.reject{ |ip| ip.persisted? }
      render :edit
    end
  end

  def location_params
    params.require(:location).permit(ips_attributes: [:address])
  end
end
