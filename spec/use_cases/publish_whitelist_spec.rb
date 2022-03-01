describe UseCases::Radius::PublishWhitelist do
  subject(:use_case) do
    described_class.new(
      destination_gateway: s3_gateway,
      generate_whitelist:,
    )
  end

  let(:generate_whitelist) do
    instance_double(
      UseCases::Radius::GenerateRadiusIpWhitelist,
      execute: whitelist,
    )
  end
  let(:s3_gateway) { instance_spy(Gateways::S3) }
  let(:whitelist) do
    'client 1-2-2-1 {
  ipaddr = 1.2.2.1
  secret = radkey1
}
'
  end

  before do
    use_case.execute
  end

  it "publishes the locations and ips" do
    expect(s3_gateway).to have_received(:write)
      .with(data: whitelist)
  end
end
