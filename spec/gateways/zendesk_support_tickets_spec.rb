describe Gateways::ZendeskSupportTickets, focus: true do
  include_context 'with a mocked support tickets client'

  subject do
    described_class.new(username: 'bob', token: 'oa2PkQAGkF4iMWw1MQ')
  end

  context 'creating a ticket' do
    before do
      ENV['ZENDESK_API_ENDPOINT'] = 'zendesk-example.api.com'
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
      expect(support_ticket_url).to eq('zendesk-example.api.com')
    end

    it 'sets the credentials on the client config' do
      expect(support_ticket_credentials).to eq(
        {
          username: 'bob',
          token: 'oa2PkQAGkF4iMWw1MQ'
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
    before { 3.times { subject.create }}

    it 'creates three tickets' do
      expect(support_tickets.count).to eq(3)
    end
  end
end
