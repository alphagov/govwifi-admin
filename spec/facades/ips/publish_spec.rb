describe Facades::Ips::Publish do
  subject(:facade) { described_class.new }
  let(:s3_client) { S3FakeClient.new_instance }
  before do
    FactoryBot.create(:ip, address: "2.2.2.2", location: FactoryBot.create(:location, id: 123, radius_secret_key: "radkey1"))
    allow(Services).to receive(:s3_client).and_return s3_client
    facade.execute
  end

  it "publishes a list of locations and ips to S3" do
    bucket = ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET")
    key = ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_OBJECT_KEY")
    expect(s3_client.get_object(key:, bucket:).body.read).to eq([{ip: "2.2.2.2", location_id: 123}].to_json)
  end

  it "publishes an IP Radius whitelist to S3" do
    whitelist = UseCases::Radius::GenerateRadiusIpWhitelist.new.execute
    bucket = ENV.fetch("S3_PUBLISHED_LOCATIONS_IPS_BUCKET")
    key = ENV.fetch("S3_WHITELIST_OBJECT_KEY")
    expect(s3_client.get_object(key:, bucket:).body.read).to eq(whitelist)
  end
end
