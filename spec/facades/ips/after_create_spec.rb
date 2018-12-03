describe Facades::Ips::AfterCreate do
  before do
    expect_any_instance_of(
      UseCases::PerformancePlatform::PublishLocationsIps
    ).to receive(:execute)
    expect_any_instance_of(PublishWhitelist).to receive(:execute)
  end

  it "executes the relevant UseCases" do
    subject.execute
  end
end
