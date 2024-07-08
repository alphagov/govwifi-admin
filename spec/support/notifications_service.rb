require "notifications/client"

shared_context "when using the notifications service" do
  let(:notifications_payload) { double }
  let(:notification_instance) { instance_double(Notifications::Client) }

  before do
    ENV["NOTIFY_API_KEY"] = "dummy_key-00000000-0000-0000-0000-000000000000-00000000-0000-0000-0000-000000000000"

    allow(Notifications::Client).to receive(:new).and_return(notification_instance)
    allow(notification_instance).to receive(:send_email).and_return({})
    allow(notification_instance).to receive(:send_sms).and_return({})
  end
end
