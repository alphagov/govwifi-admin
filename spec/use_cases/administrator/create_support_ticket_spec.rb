describe UseCases::Administrator::CreateSupportTicket do
  subject(:use_case) { described_class.new(tickets_gateway: tickets_gateway_spy) }

  let(:tickets_gateway_spy) { instance_spy(Gateways::ZendeskSupportTickets) }
  let(:message_subject) { "Admin support request" }
  let(:email) { "help@support.com" }
  let(:name) { "Helpy McHelpface" }
  let(:body) { "some details about my issue" }
  let(:expected_arguments) { { subject: message_subject, email:, name:, body: } }

  before do
    use_case.execute(
      requester: {
        email:,
        name:,
        organisation: "Parks & Rec",
      },
      details: body,
    )
  end

  it "passes the requester to the gateway" do
    expect(tickets_gateway_spy).to have_received(:create!).with(expected_arguments)
  end
end
