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

      (5 - @ips.count).times { @ips << @location.ips.build }

      render :edit
    end
  end

  def location_params
    ips = params.require(:location).permit(ips_attributes: [:address])
    ips = ips.to_h[:ips_attributes]
    present_ips = ips.reject {|_,a| a['address'].blank?}

    { ips_attributes: present_ips }
  end
end
