describe UseCases::Organisation::ViewRadiusIpAddresses do
  subject(:use_case) { described_class.new(organisation_id: org_id) }

  let(:radius_ip_1) { "111.111.111.111" }
  let(:radius_ip_2) { "121.121.121.121" }
  let(:radius_ip_3) { "131.131.131.131" }
  let(:radius_ip_4) { "141.141.141.141" }

  before do
    ENV["LONDON_RADIUS_IPS"] = "#{radius_ip_1},#{radius_ip_2}"
    ENV["DUBLIN_RADIUS_IPS"] = "#{radius_ip_3},#{radius_ip_4}"
  end

  context "with organisation one" do
    let(:org_id) { 1 }

    context "with valid IPs" do
      it "returns those IPs in a hash" do
        expect(use_case.execute).to eq(
          london: [radius_ip_1, radius_ip_2],
          dublin: [radius_ip_3, radius_ip_4],
        )
      end
    end

    context "with invalid Dublin IPs" do
      let(:radius_ip_4) { "cat.dog.bear.pig" }

      it "raises an error" do
        expect { use_case.execute }.to raise_error(IPAddr::InvalidAddressError)
      end
    end

    context "with invalid London IPs" do
      let(:radius_ip_2) { "cat.dog.bear.pig" }

      it "raises an error" do
        expect { use_case.execute }.to raise_error(IPAddr::InvalidAddressError)
      end
    end
  end

  context "with a different organisation" do
    let(:org_id) { 2 }

    it "returns those IPs in a differently ordered hash" do
      expect(use_case.execute).to eq(
        london: [radius_ip_2, radius_ip_1],
        dublin: [radius_ip_4, radius_ip_3],
      )
    end
  end

  context "with an organisation, but no RADIUS env-vars" do
    let(:org_id) { 1 }

    before do
      ENV.delete("LONDON_RADIUS_IPS")
      ENV.delete("DUBLIN_RADIUS_IPS")
    end

    it "raises an error" do
      expect { use_case.execute }.to raise_error(IndexError)
    end
  end
end
