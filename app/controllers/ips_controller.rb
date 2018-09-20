class IpsController < ApplicationController
  def new
    @ip = Ip.new
    @locations = current_locations
  end

  def create
    @ip = Ip.new(ip_params)
    @ip.location = get_location || create_location

    if @ip.save
      publish_for_performance_platform
      redirect_to(
        ips_path,
        anchor: 'ips',
        notice: "#{@ip.address} added, it will be active starting tomorrow"
      )
    else
      @ip.destroy if @ip.location.ips.count.zero?
      @locations = current_locations
      render :new
    end
  end

  def index
    @locations = Location.includes(:ips).where(organisation: current_organisation)
  end

private

  def current_locations
    current_organisation.locations.order('address ASC').map do |loc|
      ["#{loc.address}, #{loc.postcode}", loc.id]
    end
  end

  def publish_for_performance_platform
    PublishLocationsIps.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_BUCKET'),
        key: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY')
      ),
      source_gateway: Gateways::Ips.new
    ).execute
  end

  def get_location
    current_organisation.locations.find_by(id: location_params[:location_id])
  end

  def create_location
    Location.create!(
      address: location_params[:location_address],
      postcode: location_params[:location_postcode],
      organisation_id: current_organisation.id
    )
  end

  def location_params
    params.require(:ip).permit(:location_address, :location_postcode, :location_id)
  end

  def ip_params
    params.require(:ip).permit(:address)
  end
end
