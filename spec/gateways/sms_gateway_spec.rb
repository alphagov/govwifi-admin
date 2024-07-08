require_relative "../../lib/gateways/sms_gateway"
require "support/notifications_service"

describe Gateways::SmsGateway do
  subject(:sms_gateway) { described_class.new }

  let(:notification) { instance_spy(Notifications::Client, send_sms: nil) }

  before do
    ENV["NOTIFY_API_KEY"] = "dummy_key-00000000-0000-0000-0000-000000000000"
    allow(Notifications::Client).to receive(:new).and_return(notification)
  end

  context "when sending a sms" do
    let(:contact) { "+7800000005" }
    let(:username) { "test" }
    let(:template_id) { 1 }
    let(:reference) { "notify_user_account_removed" }
    let(:notifications_payload) do
      {
        phone_number: contact,
        template_id:,
        personalisation: { username: },
      }
    end

    before do
      sms_gateway.send_sms(
        contact:,
        template_id:,
        locals: { username: },
        reference:,
      )
    end

    it "calls the Notify client" do
      expect(notification).to have_received(:send_sms).with(notifications_payload)
    end
  end
end
