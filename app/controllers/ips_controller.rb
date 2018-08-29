class IpsController < ApplicationController
  def new
    @ip = Ip.new
  end

  def create
    @ip = current_user.ips.new(ip_params)
    if @ip.save
      flash[:notice] = 'IP Added: ' + @ip.address
      redirect_to ips_path(anchor: 'ips')
    else
      render :new
    end
  end

  def index
    @ips = current_user.ips
    @london_radius_ips = radius_ips[:london]
    @dublin_radius_ips = radius_ips[:dublin]
    @team_members = current_user&.organisation&.users || []
  end

  def show
    @ip = current_user.ips.find_by(id: params[:id])

    redirect_to root_path unless @ip.present?
  end

private

  def ip_params
    params.require(:ip).permit(:address)
  end

  def radius_ips
    ViewRadiusIPAddresses.new.execute
  end
end
