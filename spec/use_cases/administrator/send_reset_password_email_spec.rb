describe UseCases::Administrator::SendResetPasswordEmail do
  class SendPasswordResetEmailGatewayMock
    def send(opts)
      raise unless opts[:email] == 'test@example.com'
      raise unless opts[:locals][:reset_url] == 'https://example.com'
      raise unless opts[:template_id] == 'zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz'
      raise unless opts[:reference] == 'reset_password_email'

      {}
    end
  end

  let(:email) { 'test@example.com' }
  let(:reset_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['reset_password_email']['template_id'] }

  subject do
    described_class.new(
      notifications_gateway: SendPasswordResetEmailGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect {
      subject
        .execute(
          email: email,
          reset_url: reset_url,
          template_id: template_id
        )
    }.to_not raise_error
  end
end
