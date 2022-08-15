class Gateways::ZendeskSupportTickets
  def initialize
    @client = ZendeskAPI::Client.new do |config|
      config.url = ENV.fetch("ZENDESK_API_ENDPOINT")
      config.username = ENV.fetch("ZENDESK_API_USER")
      config.token = ENV.fetch("ZENDESK_API_TOKEN")
    end
  end

  def create!(subject:, email:, name:, body:)
    @client.tickets.create!(
      subject:,
      requester: { email:, name: name.presence || "Unknown" },
      comment: { value: body },
      tags: %w[gov_wifi],
    )
  end
end
