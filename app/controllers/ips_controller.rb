class IpsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @ip = Ip.new
  end

  def create
    Ip.create(ip_params)
  end

private

  def ip_params
    params.require(:ip).permit(:address)
  end
end
