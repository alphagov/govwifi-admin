describe UseCases::Administrator::GetAuthRequests do
  let(:authentication_logs_gateway) { spy }

  subject do
    described_class.new(
      authentication_logs_gateway: authentication_logs_gateway,
    )
  end

  context 'search results' do
    context 'search by username' do
      let(:username) { 'AAAAAA' }

      it 'calls search on the gateway' do
        subject.execute(username: username)

        expect(authentication_logs_gateway).to have_received(:search)
          .with(username: username)
      end
    end

    context 'search by ip address' do
      let(:ip) { '1.1.1.1' }

      it 'calls search on the gateway' do
        subject.execute(ips: ip)

        expect(authentication_logs_gateway).to have_received(:search)
          .with(ips: ip)
      end
    end

    context 'search by many ip addresses' do
      let(:ips) { ['1.1.1.1', '1.1.1.2', '1.1.1.3'] }

      it 'calls search on the gateway' do
        subject.execute(ips: ips)

        expect(authentication_logs_gateway).to have_received(:search)
          .with(ips: ips)
      end
    end
  end

  context 'count unique connections' do
    context 'count by IP address' do
      let(:ip) { '2.2.2.2' }

      it 'calls count distinct users on the gateway' do
        subject.execute(ips: ip)

        expect(authentication_logs_gateway).to have_received(:count_distinct_users)
          .with(no_args)
      end
    end
  end
end
