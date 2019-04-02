class LocationsController < ApplicationController
  def new
    @location = Location.new
    add_blank_ips_to_location
  end

  def create
    @location = Location.new(location_params_without_blank_ips)

    if @location.save
      Facades::Ips::Publish.new.execute
      redirect_to(
        @location.ips.any? ? location_with_ips_creation_path : location_creation_path,
        notice: "#{@location.full_address} added"
      )
    else
      add_blank_ips_to_location
      render :new
    end
  end

  def destroy
    location = current_organisation.locations.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless location && location.ips.empty?

    location.destroy
    redirect_to removed_location_ips_path, notice: "Successfully removed location #{location.address}"
  end

private

  def location_creation_path
    return created_location_new_org_ips_path if current_organisation.ips.empty?

    created_location_ips_path
  end

  def location_with_ips_creation_path
    return created_location_with_ip_new_org_ips_path if current_organisation.ips.count <= 1

    created_location_with_ip_ips_path
  end

  def add_blank_ips_to_location
    desired_count = 5
    desired_count = desired_count - @location.ips.length
    desired_count.times { @location.ips.build }
  end

  def location_params_without_blank_ips
    location_params = params
      .require(:location)
      .permit(ips_attributes: [:address])

    present_ips = location_params[:ips_attributes].reject do |_, a|
      a['address'].blank?
    end

    {
      address: params.dig(:location, :address),
      postcode: params.dig(:location, :postcode),
      organisation_id: current_organisation.id,
      ips_attributes: present_ips
    }
  end
end
