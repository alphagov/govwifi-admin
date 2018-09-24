describe SendSupportEmail do
  class SendSupportEmailGatewayMock
    def send(opts)
      puts opts
      raise unless opts[:email] == 'test@localhost'
      raise unless opts[:locals][:sender_email] == 'user@example.com'
      raise unless opts[:locals][:phone] == '11111111111'
      raise unless opts[:locals][:organisation] == 'Fake Organisation'
      raise unless opts[:locals][:details] == 'Fake details'
      raise unless opts[:locals][:name] == 'Barry Barlow'
      raise unless opts[:locals][:subject] == 'my problem'
      raise unless opts[:template_id] == 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
      raise unless opts[:reference] == 'support_email'

      {}
    end
  end

  let(:template_id) { GOV_NOTIFY_CONFIG['help_email']['template_id'] }
  let(:sender_email) { 'user@example.com' }
  let(:phone) { '11111111111' }
  let(:organisation) { 'Fake Organisation' }
  let(:details) { 'Fake details' }
  let(:name) { 'Barry Barlow' }
  let(:email) { 'test@localhost' }
  let(:email_subject) { 'my problem' }

  subject do
    described_class.new(
      notifications_gateway: SendSupportEmailGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect {
      subject
        .execute(
          template_id: template_id,
          sender_email: sender_email,
          phone: phone,
          organisation: organisation,
          details: details,
          name: name,
          email: email,
          subject: email_subject
        )
    }.to_not raise_error
  end
end