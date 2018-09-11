class PublishLocationsIps
  def initialize(upload_gateway:, statistics_gateway:)
    @upload_gateway = upload_gateway
    @statistics_gateway = statistics_gateway
  end

  def execute
    data = statistics_gateway.fetch_statistics
    upload_gateway.upload(data: data)
  end

private

  attr_reader :upload_gateway, :statistics_gateway
end