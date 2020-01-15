class UseCases::Administrator::CreateSupportTicket
  def initialize(tickets_gateway:)
    @tickets_gateway = tickets_gateway
  end

  def execute(requester:, details:)
    @tickets_gateway.create(
      subject: "Admin support request",
      email: requester[:email],
      name: requester[:name],
      body: details,
    )
  end
end
