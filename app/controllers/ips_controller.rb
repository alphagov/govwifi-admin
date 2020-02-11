class IpsController < ApplicationController
  def index
    set_ip_or_location_to_delete
    set_radius_key_rotation
    @locations = Location.includes(:ips)
      .where(organisation: current_organisation)
      .order(:address)
  end

  def destroy
    ip = current_organisation.ips.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless ip

    ip.destroy
    Facades::Ips::Publish.new.execute
    redirect_to removed_ips_path, notice: "Successfully removed IP address #{ip.address}"
  end

private

  def set_radius_key_rotation
    if key_rotation_requested?
      @key_to_rotate = current_organisation
      .locations
      .find_by(id: params.fetch(:location_id))
    end
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

  def key_rotation_requested?
    params[:location_id].present? && params[:rotate].present?
  end

  def location_removal_requested?
    params[:location_id].present? && params[:remove].present?
  end
end
