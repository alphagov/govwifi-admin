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
          .with(username: username, ip: nil)
      end
    end

    context 'search by ip address' do
      let(:ip) { '1.1.1.1' }

      it 'calls search on the gateway' do
        subject.execute(ip: ip)

        expect(authentication_logs_gateway).to have_received(:search)
          .with(username: nil, ip: ip)
      end
    end
  end
end
