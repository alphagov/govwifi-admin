describe UseCases::PerformancePlatform::PublishLocationsIps do
  subject do
    described_class.new(
      destination_gateway: s3_gateway,
      source_gateway: source_gateway
    )
  end

  let(:source_gateway) { double(fetch_ips: s3_payload) }
  let(:s3_gateway) { double }
  let(:s3_payload) do
    [
      {
        ip: "127.0.0.1",
        location_id: 1
      }, {
        ip: "186.3.1.1",
        location_id: 2
      }
    ]
  end

  before do
    expect(s3_gateway).to receive(:write)
      .with(data: s3_payload.to_json)
      .and_return({})
  end


  it "publishes the locations and ips" do
    expect(subject.execute).to eq({})
  end
end
