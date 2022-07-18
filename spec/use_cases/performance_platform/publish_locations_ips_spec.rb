describe UseCases::PerformancePlatform::PublishLocationsIps do
  before do
    @location1 = create(:location, :with_ip)
    @location2 = create(:location, :with_ip)
    described_class.new.execute
  end

  it "sends the right data to the s3 gateway" do
    data =
      [
        {
          ip: @location1.ips.first.address,
          location_id: @location1.id,
        },
        {
          ip: @location2.ips.first.address,
          location_id: @location2.id,
        },
      ]
    expect(Gateways::S3.new(**Gateways::S3::LOCATION_IPS).read).to eq(data.to_json)
  end
end
