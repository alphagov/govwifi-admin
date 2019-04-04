describe Gateways::Ips do
  subject(:ip_gateway) { described_class.new }

  let(:location_1) { create(:location, organisation: create(:organisation)) }
  let(:location_2) { create(:location, organisation: create(:organisation)) }
  let(:result) do
    [
      {
        ip: "186.3.1.2",
        location_id: location_1.id
      }, {
        ip: "186.3.1.1",
        location_id: location_2.id
      }
    ]
  end

  before do
    create(:ip, address: "186.3.1.2", location: location_1)
    create(:ip, address: "186.3.1.1", location: location_2)
  end

  it "fetches the locations_ips" do
    expect(ip_gateway.fetch_ips).to eq(result)
  end
end
