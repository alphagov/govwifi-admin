class IpsController < ApplicationController
  def new
    @ip = Ip.new
    @locations = current_organisation.locations.order('address ASC').map do |loc|
      ["#{loc.address}, #{loc.postcode}", loc.id]
    end
  end

  def create
    default_location = current_organisation.locations.first
    @ip = default_location.ips.new(ip_params)
    if @ip.save
      publish_for_performance_platform
      redirect_to(
        ips_path,
        anchor: 'ips',
        notice: "#{@ip.address} added, it will be active starting tomorrow"
      )
    else
      render :new
    end
  end

  def index
    @ips = current_organisation.ips
  end

  def show
    @ip = current_organisation.ips.find_by(id: params[:id])

    redirect_to root_path unless @ip.present?
  end

private

  def publish_for_performance_platform
    PublishLocationsIps.new(
      destination_gateway: Gateways::S3.new(
        bucket: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_BUCKET'),
        key: ENV.fetch('S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY')
      ),
      source_gateway: Gateways::Ips.new
    ).execute
  end

  def ip_params
    params.require(:ip).permit(:address)
  end
end
