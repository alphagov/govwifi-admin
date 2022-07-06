class UseCases::Radius::PublishAllowlist
  def initialize(destination_gateway:, generate_allowlist:)
    @destination_gateway = destination_gateway
    @generate_allowlist = generate_allowlist
  end

  def execute
    payload = generate_allowlist.execute
    destination_gateway.write(data: payload)
  end

private

  attr_reader :generate_allowlist, :destination_gateway
end
