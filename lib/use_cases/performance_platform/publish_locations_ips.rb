class PublishLocationsIps
  def initialize(upload_gateway:, ips_gateway:)
    @upload_gateway = upload_gateway
    @ips_gateway = ips_gateway
  end

  def execute
    payload = ips_gateway.fetch_ips
    upload_gateway.upload(data: payload)
  end

private

  attr_reader :upload_gateway, :ips_gateway
end
