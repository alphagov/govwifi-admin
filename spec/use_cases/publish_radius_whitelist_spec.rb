describe UseCases::PublishWhitelist do
  subject do
    described_class.new(
      destination_gateway: s3_gateway,
      generate_whitelist: generate_whitelist
    )
  end

  let(:generate_whitelist) { double(execute: whitelist) }
  let(:s3_gateway) { double }
  let(:whitelist) do
    'client 1-2-2-1 {
  ipaddr = 1.2.2.1
  secret = radkey1
}
'
  end

  before do
    expect(s3_gateway).to receive(:write)
      .with(data: whitelist)
      .and_return({})
  end


  it "publishes the locations and ips" do
    expect(subject.execute).to eq({})
  end
end
