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
        name: requester_name,
        body: 'some user-provided details about the issue'
      )
    end

    context 'with a name provided' do
      let(:requester_name) { 'alice' }

      it 'creates a ticket' do
        expect(support_tickets).to_not be_empty
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
        expect(support_tickets).to_not be_empty
      end

      it 'does not pass an empty name' do
        expect(support_tickets.last[:requester].keys).to_not include(:name)
      end
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
