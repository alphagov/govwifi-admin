describe Gateways::Statistics do
  let(:location_1) { create(:location, organisation: create(:organisation))}
  let(:location_2) { create(:location, organisation: create(:organisation))}

  let(:result) do
    [
      {
        ip: "127.0.0.1",
        location_id: location_1.id
      }, {
        ip: "186.3.1.1",
        location_id: location_2.id
      }
    ]
  end

  before do
    create(:ip, address: "127.0.0.1", location: location_1)
    create(:ip, address: "186.3.1.1", location: location_2)
  end

  it "fetches the statistics" do
    expect(subject.fetch_statistics).to eq(result)
  end
end