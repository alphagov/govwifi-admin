describe Facades::Ips::AfterCreate do
  let(:ip) { create(:ip) }
  let(:subject) { described_class.new(ip: ip) }

  it "executes the relevant UseCases" do
    expect_any_instance_of(
      UseCases::PerformancePlatform::PublishLocationsIps
    ).to receive(:execute)
    expect_any_instance_of(PublishWhitelist).to receive(:execute)

    subject.execute
  end
end
