class IpsController < ApplicationController
  before_action :authorise_manage_locations, only: %i(create new)

  def new
    selected_location = Location.find_by(id: params[:location])
    @ip = Ip.new(location: selected_location)
    @locations = available_locations
  end

  def create
    @ip = Ip.new(ip_params)

    if @ip.save
      Facades::Ips::AfterCreate.new.execute
      redirect_to(
        ips_path,
        notice: "#{@ip.address} added, it will be active starting tomorrow"
      )
    else
      @locations = available_locations
      render :new
    end
  end

  def index
    set_ip_or_location_to_delete
    @locations = Location.includes(:ips)
      .where(organisation: current_organisation)
      .order(:address)
  end

  def destroy
    ip = current_organisation.ips.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless ip

    ip.destroy
    redirect_to ips_path, notice: "Successfully removed IP address #{ip.address}"
  end

private

  def available_locations
    current_organisation.locations.order(:address)
  end

  def ip_params
    params.require(:ip).permit(:address, :location_id)
  end

  def set_ip_or_location_to_delete
    if ip_removal_requested?
      @ip_to_delete = current_organisation.ips.find_by(id: params.fetch(:ip_id))
    elsif location_removal_requested?
      @location_to_delete = current_organisation
        .locations
        .find_by(id: params.fetch(:location_id))
    end
  end

  def ip_removal_requested?
    params[:ip_id].present?
  end

  def location_removal_requested?
    params[:location_id].present?
  end
end
