describe UseCases::Administrator::GetAuthRequests do
  subject(:use_case) do
    described_class.new(
      authentication_logs_gateway: authentication_logs_gateway,
    )
  end

  let(:authentication_logs_gateway) { spy }

  context "when searching by username" do
    let(:username) { "AAAAAA" }

    it "calls search on the gateway" do
      use_case.execute(username: username)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(username: username)
    end
  end

  context "when searching by ip address" do
    let(:ip) { "1.1.1.1" }

    it "calls search on the gateway" do
      use_case.execute(ips: ip)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(ips: ip)
    end
  end

  context "when searching by many ip addresses" do
    let(:ips) { ["1.1.1.1", "1.1.1.2", "1.1.1.3"] }

    it "calls search on the gateway" do
      use_case.execute(ips: ips)

      expect(authentication_logs_gateway).to have_received(:search)
        .with(ips: ips)
    end
  end
end
