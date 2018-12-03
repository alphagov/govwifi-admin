class IpsController < ApplicationController
  before_action :authorise_manage_locations, only: %i(create new)

  def new
    @ip = Ip.new
    @locations = available_locations
  end

  def create
    @ip = Ip.new(create_params)

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
    set_ip_to_delete if ip_removal_requested?
    @locations = Location.includes(:ips).where(organisation: current_organisation).order(:address)
  end

  def destroy
    ip = current_organisation.ips.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless ip

    ip.destroy
    redirect_to ips_path, notice: "Successfully removed IP address #{ip.address}"
  end

private

  def available_locations
    current_organisation.locations.order('address ASC').map do |loc|
      ["#{loc.address}, #{loc.postcode}", loc.id]
    end
  end

  def ip_params
    params.require(:ip).permit(:address, :location_id, location_attributes: %i[address postcode])
  end

  def create_params
    return params_with_new_location if user_creates_new_location?
    params_with_existing_location
  end

  def user_creates_new_location?
    ip_params[:location_id].blank?
  end

  def params_with_new_location
    p = ip_params.except(:location_id)
    p[:location_attributes][:organisation] = current_organisation
    p
  end

  def params_with_existing_location
    ip_params.except(:location_attributes)
  end

  def set_ip_to_delete
    @ip_to_delete = current_organisation.ips.find_by(id: params.fetch(:ip_id))
  end

  def ip_removal_requested?
    params[:ip_id].present?
  end
end
