class LocationsController < ApplicationController
  before_action :authorise_manage_locations

  def new
    @first = params[:first] == "true"
    @organisation_specific = !@first
    @location = Location.new
    render :new
  end

  def create
    @location = Location.new(
      address: params.dig(:location, :address),
      postcode: params.dig(:location, :postcode),
      organisation_id: current_organisation.id,
    )

    if @location.save
      redirect_to created_location_ips_path
    else
      render :new
    end
  end

  def update
    location = Location.find(params[:id])
    location.update(radius_secret_key: rotate_radius_secret_key)
    redirect_to(ips_path, notice: 'RADIUS secret key has been successfully rotated')
  end

  def add_ips
    @location = Location.find(params[:location_id])
    @location.add_blank_ips(5)
  end

  def update_ips
    @location = Location.find(params[:location_id])
    length_of_ips_before = @location.ips.length
    if !present_ips.empty? && @location.update(ips_attributes: present_ips)
      Facades::Ips::Publish.new.execute
      length_of_ips_added = @location.ips.length - length_of_ips_before
      redirect_to(
        created_ips_path,
        notice: "Added #{length_of_ips_added} #{'IP address'.pluralize(length_of_ips_added)} to #{@location.full_address}"
      )
    else
      @location.add_blank_ips(5)
      render :add_ips
    end
  end

  def destroy
    location = current_organisation.locations.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless location && location.ips.empty?

    location.destroy
    redirect_to removed_location_ips_path, notice: "Successfully removed location #{location.address}"
  end

private

  def rotate_radius_secret_key
    use_case = UseCases::Administrator::GenerateRadiusSecretKey.new
    use_case.execute
  end

  def present_ips
    location_params = params
      .require(:location)
      .permit(ips_attributes: [:address])
    location_params[:ips_attributes].reject do |_, a|
      a['address'].blank? || @location.ips.map(&:address).include?(a['address'])
    end
  end
end
