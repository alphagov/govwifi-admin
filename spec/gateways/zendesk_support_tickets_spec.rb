describe Gateways::ZendeskSupportTickets do
  include_context 'with a mocked support tickets client'

  context 'creating a ticket' do
    before do
      ENV['ZENDESK_API_ENDPOINT'] = 'https://zendesk-example.api.com'
      ENV['ZENDESK_API_USER'] = 'example-zendesk-admin@user.com'
      ENV['ZENDESK_API_TOKEN'] = 'abcdefghihgfedcba'

      subject.create(
        subject: 'example subject',
        email: 'alice@company.com',
        name: 'alice',
        body: 'some user-provided details about the issue'
      )
    end

    it 'creates a ticket' do
      expect(support_tickets).to_not be_empty
    end

    it 'sets the url on the client config' do
      expect(support_ticket_url).to eq('https://zendesk-example.api.com')
    end

    it 'sets the credentials on the client config' do
      expect(support_ticket_credentials).to eq(
        {
          username: 'example-zendesk-admin@user.com',
          token: 'abcdefghihgfedcba'
        }
      )
    end

    it 'passes the subject to the client' do
      expect(support_tickets.last[:subject]).to eq 'example subject'
    end

    it 'passes the requester to the client' do
      expect(support_tickets.last[:requester]).to eq(
        {
          email: 'alice@company.com',
          name: 'alice'
        }
      )
    end

    it 'passes the body to the client' do
      expect(support_tickets.last[:comment]).to eq(
        {
          value: 'some user-provided details about the issue'
        }
      )
    end
  end

  context 'creating multiple tickets' do
    before do
      3.times do
        subject.create(
          subject: 'example subject',
          email: 'alice@company.com',
          name: 'alice',
          body: 'some user-provided details about the issue'
        )
      end
    end

    it 'creates three tickets' do
      expect(support_tickets.count).to eq(3)
    end
  end
end
