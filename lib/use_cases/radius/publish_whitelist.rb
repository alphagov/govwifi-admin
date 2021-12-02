class UseCases::Radius::PublishWhitelist
  def initialize(destination_gateway:, generate_whitelist:)
    @destination_gateway = destination_gateway
    @generate_whitelist = generate_whitelist
  end

  def execute
    payload = generate_whitelist.execute
    destination_gateway.write(data: payload)
  end

private

  attr_reader :generate_whitelist, :destination_gateway
end
