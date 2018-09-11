class PublishLocationsIps
  def initialize(upload_gateway:, ips_gateway:)
    @upload_gateway = upload_gateway
    @ips_gateway = ips_gateway
  end

  def execute
    results = ips_gateway.fetch_ips
    upload_gateway.upload(data: generate_payload(results))
  end

private

  def generate_payload(results)
    results.map do |ip|
      {
        ip: ip.address,
        location_id: ip.location_id
      }
    end
  end

  attr_reader :upload_gateway, :ips_gateway
end
