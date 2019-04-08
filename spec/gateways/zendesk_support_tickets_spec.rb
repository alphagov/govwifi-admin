describe Gateways::ZendeskSupportTickets do
  include_context 'with a mocked support tickets client'
  subject(:ticket_gateway) { described_class.new }

  context 'when creating a ticket' do
    before do
      ENV['ZENDESK_API_ENDPOINT'] = 'https://zendesk-example.api.com'
      ENV['ZENDESK_API_USER'] = 'example-zendesk-admin@user.com'
      ENV['ZENDESK_API_TOKEN'] = 'abcdefghihgfedcba'

      ticket_gateway.create(
        subject: 'example subject',
        email: 'alice@company.com',
        name: requester_name,
        body: 'some user-provided details about the issue'
      )
    end

    context 'with a name provided' do
      let(:requester_name) { 'alice' }

      it 'creates a ticket' do
        expect(support_tickets).not_to be_empty
      end

      it 'sets the url on the client config' do
        expect(support_ticket_url).to eq('https://zendesk-example.api.com')
      end

      it 'sets the credentials on the client config' do
        expect(support_ticket_credentials).to eq(
          username: 'example-zendesk-admin@user.com',
          token: 'abcdefghihgfedcba'
        )
      end

      it 'passes the subject to the client' do
        expect(support_tickets.last[:subject]).to eq 'example subject'
      end

      it 'passes the requester to the client' do
        expect(support_tickets.last[:requester]).to eq(
          email: 'alice@company.com',
          name: requester_name
        )
      end

      it 'passes the body to the client' do
        expect(support_tickets.last[:comment]).to eq(
          value: 'some user-provided details about the issue'
        )
      end

      it 'passes the right tag to the client' do
        expect(support_tickets.last[:tags]).to eq(%w[gov_wifi])
      end
    end

    context 'with no name provided' do
      let(:requester_name) { '' }

      it 'creates a ticket' do
        expect(support_tickets).not_to be_empty
      end

      it 'marks the requester name as unknown' do
        expect(support_tickets.last[:requester][:name]).to eq('Unknown')
      end
    end
  end

  context 'when creating multiple tickets' do
    before do
      3.times do
        ticket_gateway.create(
          subject: 'example subject',
          email: 'alice@company.com',
          name: 'alice',
          body: 'some user-provided details about the issue'
        )
      end
    end

    it 'creates all desired number of tickets' do
      expect(support_tickets.count).to eq(3)
    end
  end
end
