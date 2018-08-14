describe SendConfirmationEmail do
  class NotificationsGatewayMock
    def send(opts)
      raise unless opts[:email] == 'test@example.com'
      raise unless opts[:locals][:confirmation_url] == 'https://example.com'
      raise unless opts[:template_id] == '5f42e490-ce5e-44e7-9104-805136961116'
      raise unless opts[:reference] == 'confirmation_email'

      {}
    end
  end

  let(:email) { 'test@example.com' }
  let(:confirmation_url) { 'https://example.com' }

  subject do
    described_class.new(
      notifications_gateway: NotificationsGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect { subject.execute(email: email, confirmation_url: confirmation_url) }
      .to_not raise_error
  end
end
