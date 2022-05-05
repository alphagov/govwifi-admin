require "support/notifications_service"

describe Gateways::EmailGateway do
  subject(:email_gateway) { described_class }

  let(:notification) { instance_spy(Notifications::Client, send_email: nil) }

  before do
    ENV["NOTIFY_API_KEY"] = "dummy_key-00000000-0000-0000-0000-000000000000-00000000-0000-0000-0000-000000000000"
    allow(Notifications::Client).to receive(:new).and_return(notification)
  end

  context "when sending a confirmation email" do
    let(:email) { "test@example.com" }
    let(:confirmation_url) { "http://example.com/confirm?token=123" }
    let(:template_id) { 1 }
    let(:reference) { "confirmation_email" }
    let(:notifications_payload) do
      {
        email_address: "test@example.com",
        template_id: 1,
        personalisation: { confirmation_url: },
        reference: "confirmation_email",
      }
    end

    before do
      email_gateway.send_email(
        email:,
        template_id:,
        locals: { confirmation_url: },
        reference:,
      )
    end

    it "calls the Notify client" do
      expect(notification).to have_received(:send_email).with(notifications_payload)
    end
  end
end
