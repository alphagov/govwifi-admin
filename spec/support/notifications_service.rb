shared_examples 'notifications service' do
  let(:notifications_payload) { double }
   before do
    ENV['NOTIFICATIONS_API_KEY'] = 'dummy_key-00000000-0000-0000-0000-000000000000-00000000-0000-0000-0000-000000000000'
     allow_any_instance_of(Notifications::Client).to \
      receive(:send_email).and_return({})
  end
end 