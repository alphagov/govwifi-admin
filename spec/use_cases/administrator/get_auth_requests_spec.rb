describe UseCases::Administrator::GetAuthRequests do
  let(:authentication_logs_gateway) { spy }
  let(:search_validator) { double(execute: { success: true }) }

  subject do
    described_class.new(
      authentication_logs_gateway: authentication_logs_gateway,
      search_validator: search_validator
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

      context 'invalid username' do
        let(:search_validator) { double(execute: { success: false }) }

        it 'returns an empty result' do
          expect(
            subject.execute(username: username)
          ).to eq(
            error: 'There was a problem with your search', results: []
          )
        end
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
