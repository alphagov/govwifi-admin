describe UseCases::Organisation::ViewRadiusIPAddresses do
  subject { described_class.new(organisation_id: org_id) }

  context 'with RADIUS environment variables' do
    before do
      ENV['LONDON_RADIUS_IPS'] = "#{radius_ip_1},#{radius_ip_2}"
      ENV['DUBLIN_RADIUS_IPS'] = "#{radius_ip_3},#{radius_ip_4}"
    end

    context 'as organisation 1' do
      let(:org_id) { 1 }

      context 'example one' do
        let(:radius_ip_1) { '111.111.111.111' }
        let(:radius_ip_2) { '121.121.121.121' }
        let(:radius_ip_3) { '131.131.131.131' }
        let(:radius_ip_4) { '141.141.141.141' }

        it 'returns those IPs in a hash' do
          expect(subject.execute).to eq(
            london: [radius_ip_1, radius_ip_2],
            dublin: [radius_ip_3, radius_ip_4]
          )
        end
      end

      context 'example two' do
        let(:radius_ip_1) { '151.151.151.151' }
        let(:radius_ip_2) { '161.161.161.161' }
        let(:radius_ip_3) { '171.171.171.171' }
        let(:radius_ip_4) { '181.181.181.181' }

        it 'returns those IPs in a hash' do
          expect(subject.execute).to eq(
            london: [radius_ip_1, radius_ip_2],
            dublin: [radius_ip_3, radius_ip_4]
          )
        end
      end

      context 'including invalid Dublin IPs' do
        let(:radius_ip_1) { '111.111.111.111' }
        let(:radius_ip_2) { '121.121.121.121' }
        let(:radius_ip_3) { '131.131.131.131' }
        let(:radius_ip_4) { 'cat.dog.bear.pig' }

        it 'blows up' do
          expect { subject.execute }.to raise_error(IPAddr::InvalidAddressError)
        end
      end

      context 'including invalid London IPs' do
        let(:radius_ip_1) { '111.111.111.111' }
        let(:radius_ip_2) { 'cat.dog.bear.pig' }
        let(:radius_ip_3) { '131.131.131.131' }
        let(:radius_ip_4) { '141.141.141.141' }

        it 'blows up' do
          expect { subject.execute }.to raise_error(IPAddr::InvalidAddressError)
        end
      end
    end

    context 'as organisation 2' do
      let(:org_id) { 2 }

      let(:radius_ip_1) { '111.111.111.111' }
      let(:radius_ip_2) { '121.121.121.121' }
      let(:radius_ip_3) { '131.131.131.131' }
      let(:radius_ip_4) { '141.141.141.141' }

      it 'returns those IPs in a differently ordered hash' do
        expect(subject.execute).to eq(
          london: [radius_ip_2, radius_ip_1],
          dublin: [radius_ip_4, radius_ip_3]
        )
      end
    end
  end

  context 'with an organisation, but no RADIUS env-vars' do
    let(:org_id) { 1 }

    before do
      ENV.delete('LONDON_RADIUS_IPS')
      ENV.delete('DUBLIN_RADIUS_IPS')
    end

    it 'blows up' do
      expect { subject.execute }.to raise_error(IndexError)
    end
  end
end
