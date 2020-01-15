describe Gateways::Route53 do
  subject(:route_gateway) { described_class.new }

  it "calls the .list_health_checks method" do
    expect(route_gateway.list_health_checks.health_checks).to be_empty
  end

  it "calls the .get_health_check_status method" do
    expect(route_gateway.get_health_check_status(health_check_id: "abc").health_check_observations).to be_empty
  end
end
