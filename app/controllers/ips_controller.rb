class IpsController < ApplicationController
  def new
    @ip = Ip.new
  end

  def create
    current_user.ips.create!(ip_params)
    render :show
  end

private

  def ip_params
    params.require(:ip).permit(:address)
  end
end
