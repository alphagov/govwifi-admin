class PublishLocationsIps
  def initialize(destination_gateway:, source_gateway:)
    @destination_gateway = destination_gateway
    @source_gateway = source_gateway
  end

  def execute
    payload = source_gateway.fetch_ips.to_json
    destination_gateway.upload(data: payload)
  end

private

  attr_reader :destination_gateway, :source_gateway
end
