describe SendConfirmationEmail do
  class NotificationsGatewayMock
    def send(opts)
      raise unless opts[:email] == 'test@example.com'
      raise unless opts[:locals][:confirmation_url] == 'https://example.com'
      raise unless opts[:template_id] == 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      raise unless opts[:reference] == 'confirmation_email'

      {}
    end
  end

  let(:email) { 'test@example.com' }
  let(:confirmation_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['confirmation_email']['template_id'] }

  subject do
    described_class.new(
      notifications_gateway: NotificationsGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect {
      subject
        .execute(
          email: email,
          confirmation_url: confirmation_url,
          template_id: template_id
        )
    }.to_not raise_error
  end
end
