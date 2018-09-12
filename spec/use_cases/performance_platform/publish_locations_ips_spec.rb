describe PublishLocationsIps do
  let(:ips_gateway) { double(fetch_ips: s3_payload) }
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
    expect(s3_gateway).to receive(:upload)
      .with(data: s3_payload)
      .and_return({})
  end

  subject do
    described_class.new(
      upload_gateway: s3_gateway,
      ips_gateway: ips_gateway
    )
  end

  it "publishes the locations and ips" do
    expect(subject.execute).to eq({})
  end
end
