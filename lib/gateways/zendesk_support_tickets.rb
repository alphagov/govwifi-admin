class Gateways::ZendeskSupportTickets
  def initialize(username:, token:)
    @client = ZendeskAPI::Client.new do |config|
      config.url = 'zendesk-example.api.com'
      config.username = username
      config.token = token
    end
  end

  def create(subject: '', email: '', name: '', body: '')
    @client.tickets.create(
      subject: subject,
      requester: {
        email: email,
        name: name
      },
      comment: {
        value: body
      }
    )
  end
end
