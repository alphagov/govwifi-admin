describe Facades::Ips::Publish do
  subject(:facade) { described_class.new }

  let(:publish_location_ips) { instance_spy(UseCases::PerformancePlatform::PublishLocationsIps, execute: nil) }
  let(:publish_allowlist) { instance_spy(UseCases::Radius::PublishAllowlist, execute: nil) }

  before do
    allow(UseCases::PerformancePlatform::PublishLocationsIps).to receive(:new).and_return(publish_location_ips)
    allow(UseCases::Radius::PublishAllowlist).to receive(:new).and_return(publish_allowlist)
    facade.execute
  end

  it "executes the publish location & ips usecase" do
    expect(publish_location_ips).to have_received(:execute)
  end

  it "executes the publish allowlist usecase" do
    expect(publish_allowlist).to have_received(:execute)
  end
end
