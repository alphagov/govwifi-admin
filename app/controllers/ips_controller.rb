class IpsController < ApplicationController
  def new
    @ip = Ip.new
  end

  def create
    @ip = current_user.ips.new(ip_params)
    if @ip.save
      redirect_to @ip
    else
      render :new
    end
  end

  def index
    @ips = current_user.ips
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
  end

  def show
    @ip = Ip.find(params[:id])
  end

private

  def ip_params
    params.require(:ip).permit(:address)
  end

  def radius_ips
    ViewRadiusIPAddresses.new.execute
  end
end
