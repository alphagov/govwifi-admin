describe UseCases::Radius::PublishRadiusIpAllowlist do
  let(:organisation) { create(:organisation) }
  let(:location1) { create(:location, organisation:) }
  let(:location2) { create(:location, organisation:) }
  let(:configuration_result) { Gateways::S3.new(**Gateways::S3::RADIUS_IPS_ALLOW_LIST).read }

  before do
    location1.ips << create(:ip, address: "1.1.1.1")
    location1.ips << create(:ip, address: "1.2.2.1")
    location2.ips << create(:ip, address: "2.2.2.2")
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
      described_class.new.execute
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
      location1.destroy!
      described_class.new.execute
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
      Ip.first.destroy!
      described_class.new.execute
    end

    it "omits IP entry" do
      expect(configuration_result).to eq(correct_configuration)
    end
  end
end
