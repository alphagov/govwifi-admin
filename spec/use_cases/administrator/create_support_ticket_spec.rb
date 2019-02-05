describe UseCases::Administrator::CreateSupportTicket do
  subject { described_class.new(tickets_gateway: tickets_gateway_spy) }

  let(:tickets_gateway_spy) { spy(:create) }

  before do
    subject.execute(
      requester: {
        email: 'help@support.com',
        name: 'Helpy McHelpface',
        organisation: 'Parks & Rec'
      },
      details: 'some details about my issue'
    )
  end

  it 'passes the requester to the gateway' do
    expect(tickets_gateway_spy).to have_received(:create) do |args|
      expect(args[:subject]).to eq 'Admin support request'
      expect(args[:email]).to eq 'help@support.com'
      expect(args[:name]).to eq 'Helpy McHelpface'
      expect(args[:body]).to eq 'some details about my issue'
    end
  end
end
