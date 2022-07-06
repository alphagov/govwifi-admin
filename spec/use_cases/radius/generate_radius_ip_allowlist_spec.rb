describe UseCases::Radius::GenerateRadiusIpAllowlist do
  let(:organisation) { create(:organisation) }
  let(:location1) { create(:location, organisation:) }
  let(:location2) { create(:location, organisation:) }
  let(:configuration_result) { described_class.new.execute }

  before do
    create(:ip, address: "1.1.1.1", location: location1)
    create(:ip, address: "1.2.2.1", location: location1)
    create(:ip, address: "2.2.2.2", location: location2)
    location1.update!(radius_secret_key: "radkey1")
    location2.update!(radius_secret_key: "radkey2")
  end

  context "with locations and IPs" do
    let(:correct_configuration) do
      'client 1-1-1-1 {
      ipaddr = 1.1.1.1
      secret = radkey1
    }
    client 1-2-2-1 {
      ipaddr = 1.2.2.1
      secret = radkey1
    }
    client 2-2-2-2 {
      ipaddr = 2.2.2.2
      secret = radkey2
    }
    '
    end

    it "returns the correct configuration" do
      expect(configuration_result).to eq(correct_configuration)
    end
  end

  context "with no location" do
    let(:correct_configuration) do
      'client 2-2-2-2 {
      ipaddr = 2.2.2.2
      secret = radkey2
    }
    '
    end

    before do
      location1.destroy
    end

    it "omits this IP" do
      expect(configuration_result).to eq(correct_configuration)
    end
  end

  context "when a location has no IPs" do
    let(:correct_configuration) do
      'client 1-2-2-1 {
      ipaddr = 1.2.2.1
      secret = radkey1
    }
    client 2-2-2-2 {
      ipaddr = 2.2.2.2
      secret = radkey2
    }
    '
    end

    before do
      Ip.first.destroy
    end

    it "omits IP entry" do
      expect(configuration_result).to eq(correct_configuration)
    end
  end
end
