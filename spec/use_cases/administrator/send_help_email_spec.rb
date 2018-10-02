describe UseCases::Administrator::SendHelpEmail do
  class SendHelpEmailGatewayMock
    def send(opts)
      raise unless opts[:email] == 'test@localhost'
      raise unless opts[:locals][:details] == 'some problem'
      raise unless opts[:locals][:subject] == 'my problem'
      raise unless opts[:locals][:sender_email] == 'sender@example.com'
      raise unless opts[:locals][:organisation] == 'organisation'
      raise unless opts[:locals][:name] == 'Name'
      raise unless opts[:locals][:phone] == '01234567890'
      raise unless opts[:template_id] == 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
      raise unless opts[:reference] == 'help_email'
      {}
    end
  end

  let(:email) { GOV_NOTIFY_CONFIG['support_email'] }
  let(:confirmation_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['help_email']['template_id'] }
  let(:details) { 'some problem' }
  let(:email_subject) { 'my problem' }
  let(:sender_email) { 'sender@example.com' }
  let(:organisation) { 'organisation' }
  let(:name) { 'Name' }
  let(:phone) { '01234567890' }

  subject do
    described_class.new(
      notifications_gateway: SendHelpEmailGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect {
      subject
        .execute(
          email: email,
          template_id: template_id,
          details: details,
          name: name,
          subject: email_subject,
          sender_email: sender_email,
          phone: phone,
          organisation: organisation
        )
    }.to_not raise_error
  end
end
