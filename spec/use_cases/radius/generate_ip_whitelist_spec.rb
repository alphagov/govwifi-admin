describe UseCases::Radius::GenerateRadiusIpWhitelist do
  let(:organisation) { create(:organisation) }
  let(:location1) { create(:location, organisation: organisation) }
  let(:location2) { create(:location, organisation: organisation) }

  before do
    create(:ip, address: '1.1.1.1', location: location1)
    create(:ip, address: '1.2.2.1', location: location1)
    create(:ip, address: '2.2.2.2', location: location2)

    location1.update(radius_secret_key: 'radkey1')
    location2.update(radius_secret_key: 'radkey2')
  end

  let(:configuration_result) { subject.execute }

  describe '#execute' do
    it 'returns the correct configuration' do
      expect(configuration_result).to eq('client 1-1-1-1 {
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
    ')
    end
  end

  context 'with no location' do
    before do
      location1.destroy
    end

    it 'omits this IP' do
      expect(configuration_result).to eq('client 2-2-2-2 {
      ipaddr = 2.2.2.2
      secret = radkey2
    }
    ')
    end
  end

  context 'a location with no IPs' do
    before do
      Ip.first.destroy
    end

    it 'omits IP this entry' do
      expect(configuration_result).to eq('client 1-2-2-1 {
      ipaddr = 1.2.2.1
      secret = radkey1
    }
    client 2-2-2-2 {
      ipaddr = 2.2.2.2
      secret = radkey2
    }
    ')
    end
  end
end
