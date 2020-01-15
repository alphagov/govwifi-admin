describe UseCases::Administrator::GetPostcodeCoordinates do
  subject(:use_case) { described_class.new(postcodes_gateway: gateway) }

  let(:gateway) do
    instance_double(Gateways::Coordinates, fetch_coordinates: [])
  end

  it "calls fetch_coordinates on the gateway" do
    use_case.execute
    expect(gateway).to have_received(:fetch_coordinates)
  end

  it "formats the results into latitude and longitude coordinates" do
    allow(gateway).to receive(:fetch_coordinates).and_return([
      { latitude: 123, longitude: 456 },
      { latitude: 789, longitude: 198 },
    ])

    expect(use_case.execute).to eq([[123, 456], [789, 198]])
  end
end
