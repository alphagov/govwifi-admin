describe ViewRadiusIPAddresses do
  subject { described_class.new }

  context 'with RADIUS environment variables' do
    before do
      ENV['LONDON_RADIUS_IPS'] = "#{radius_ip_1},#{radius_ip_2}"
      ENV['DUBLIN_RADIUS_IPS'] = "#{radius_ip_3},#{radius_ip_4}"
    end

    context 'example one' do
      let(:radius_ip_1) { '111.111.111.111' }
      let(:radius_ip_2) { '121.121.121.121' }
      let(:radius_ip_3) { '131.131.131.131' }
      let(:radius_ip_4) { '141.141.141.141' }

      it 'returns those IPs in a hash' do
        expect(subject.execute).to eq({
          london: [radius_ip_1, radius_ip_2],
          dublin: [radius_ip_3, radius_ip_4]
        })
      end
    end

    context 'example two' do
      let(:radius_ip_1) { '151.151.151.151' }
      let(:radius_ip_2) { '161.161.161.161' }
      let(:radius_ip_3) { '171.171.171.171' }
      let(:radius_ip_4) { '181.181.181.181' }

      it 'returns those IPs in a hash' do
        expect(subject.execute).to eq({
          london: [radius_ip_1, radius_ip_2],
          dublin: [radius_ip_3, radius_ip_4]
        })
      end
    end

    context 'including invalid Dublin IPs' do
      let(:radius_ip_1) { '111.111.111.111' }
      let(:radius_ip_2) { '121.121.121.121' }
      let(:radius_ip_3) { '131.131.131.131' }
      let(:radius_ip_4) { 'cat.dog.bear.pig' }

      it 'blows up' do
        expect{ subject.execute }.to raise_error(IPAddr::InvalidAddressError)
      end
    end

    context 'including invalid London IPs' do
      let(:radius_ip_1) { '111.111.111.111' }
      let(:radius_ip_2) { 'cat.dog.bear.pig' }
      let(:radius_ip_3) { '131.131.131.131' }
      let(:radius_ip_4) { '141.141.141.141' }

      it 'blows up' do
        expect{ subject.execute }.to raise_error(IPAddr::InvalidAddressError)
      end
    end
  end

  context 'with no RADIUS env-vars' do
    before do
      ENV.delete('LONDON_RADIUS_IPS')
      ENV.delete('DUBLIN_RADIUS_IPS')
    end

    it 'blows up' do
      expect{ subject.execute }.to raise_error(IndexError)
    end
  end
end
