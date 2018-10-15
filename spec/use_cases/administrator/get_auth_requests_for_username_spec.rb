describe UseCases::Administrator::GetAuthRequestsForUsername do
  let(:authentication_logs_gateway) { double }
  let(:username) { 'AAAAAA' }

  subject do
    described_class.new(authentication_logs_gateway: authentication_logs_gateway)
  end

  before do
    allow(authentication_logs_gateway).to receive(:search)
  end

  it 'calls search on the gateway' do
    subject.execute(username: username)

    expect(authentication_logs_gateway).to have_received(:search).with(username: username)
  end

  context 'invalid username' do
    let(:invalid_usernames) { ['1', '', nil, 'morethan6chars', 'b'] }

    it 'returns an empty result' do
      invalid_usernames.each do |username|
        expect(subject.execute(username: username)).to eq(error: 'Username must be 6 characters in length.', results: [])
      end
    end
  end
end
