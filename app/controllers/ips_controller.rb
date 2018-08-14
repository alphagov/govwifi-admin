class IpsController < ApplicationController
  def new
    @ip = Ip.new
  end

  def create
    ip = current_user.ips.create!(ip_params)
    redirect_to ip
  end

  def index
    @ips = current_user.ips
  end

  def show
    @ip = Ip.find(params[:id])
  end

private

  def ip_params
    params.require(:ip).permit(:address)
  end
end
