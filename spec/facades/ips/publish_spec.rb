describe Facades::Ips::Publish do
  subject(:facade) { described_class.new }

  let(:publish_location_ips) { instance_spy(UseCases::PerformancePlatform::PublishLocationsIps, execute: nil) }
  let(:publish_whitelist) { instance_spy(PublishWhitelist, execute: nil) }

  before do
    allow(UseCases::PerformancePlatform::PublishLocationsIps).to receive(:new).and_return(publish_location_ips)
    allow(PublishWhitelist).to receive(:new).and_return(publish_whitelist)
    facade.execute
  end

  it "executes the publish location & ips usecase" do
    expect(publish_location_ips).to have_received(:execute)
  end

  it "executes the publish whitelist usecase" do
    expect(publish_whitelist).to have_received(:execute)
  end
end
