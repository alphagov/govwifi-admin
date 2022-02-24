describe UseCases::Administrator::GetAuthRequests do
  subject(:use_case) do
    described_class.new(
      authentication_logs_gateway:,
    )
  end

  let(:authentication_logs_gateway) { spy }

  context "when searching by username" do
    let(:username) { "AAAAAA" }
    let(:success) { nil }
    let(:ips) { nil }

    it "calls search on the gateway" do
      use_case.execute(username:)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(username:, success:, ips:)
    end
  end

  context "when searching by ip address" do
    let(:ip) { "1.1.1.1" }
    let(:username) { nil }
    let(:success) { nil }

    it "calls search on the gateway" do
      use_case.execute(ips: ip)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(ips: ip, success:, username:)
    end
  end

  context "when searching by many ip addresses" do
    let(:ips) { ["1.1.1.1", "1.1.1.2", "1.1.1.3"] }
    let(:username) { nil }
    let(:success) { nil }

    it "calls search on the gateway" do
      use_case.execute(ips:)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(ips:, success:, username:)
    end
  end
end
