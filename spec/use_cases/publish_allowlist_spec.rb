describe UseCases::Radius::PublishAllowlist do
  subject(:use_case) do
    described_class.new(
      destination_gateway: s3_gateway,
      generate_allowlist:,
    )
  end

  let(:generate_allowlist) do
    instance_double(
      UseCases::Radius::GenerateRadiusIpAllowlist,
      execute: allowlist,
    )
  end
  let(:s3_gateway) { instance_spy(Gateways::S3) }
  let(:allowlist) do
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
      .with(data: allowlist)
  end
end
