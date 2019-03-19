describe UseCases::Administrator::CreateSupportTicket do
  subject(:use_case) { described_class.new(tickets_gateway: tickets_gateway_spy) }

  let(:tickets_gateway_spy) { instance_spy("Gateways::ZendeskSupportTickets", :create) }
  let(:valid_args) do
    {
      subject: 'Admin support request',
      email: 'help@support.com',
      name: 'Helpy McHelpface',
      body: 'some details about my issue'
    }
  end

  before do
    use_case.execute(
      requester: {
        email: 'help@support.com',
        name: 'Helpy McHelpface',
        organisation: 'Parks & Rec'
      },
      details: 'some details about my issue'
    )
  end

  it 'passes the requester to the gateway' do
    expect(tickets_gateway_spy).to have_received(:create).with(valid_args)
  end
end
