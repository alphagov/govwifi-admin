describe UseCases::PerformancePlatform::PublishLocationsIps do
  subject(:use_case) do
    described_class.new(
      destination_gateway: s3_gateway,
      source_gateway:,
    )
  end

  let(:source_gateway) { instance_double(Gateways::Ips, fetch_ips: s3_payload) }
  let(:s3_gateway) { instance_spy(Gateways::S3) }
  let(:s3_payload) do
    [
      {
        ip: "127.0.0.1",
        location_id: 1,
      },
      {
        ip: "186.3.1.1",
        location_id: 2,
      },
    ]
  end

  before do
    use_case.execute
  end

  it "sends the right data to the s3 gateway" do
    expect(s3_gateway).to have_received(:write)
      .with(data: s3_payload.to_json)
  end
end
