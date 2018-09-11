describe PublishLocationsIps do
  let(:s3_gateway) { double }
  let(:data_gateway) { double(fetch_statistics: locations_ips) }
  let(:locations_ips) do
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
      .with(data: locations_ips)
      .and_return({})
  end

  subject do 
    described_class.new(
      upload_gateway: s3_gateway,
      statistics_gateway: data_gateway
    )
  end

  it "publishes the locations and ips" do
    expect(subject.execute).to eq({})
  end
end