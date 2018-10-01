describe UseCases::Administrator::NotifySupportOfNewUser do
  class NotifySupportOfNewUserGatewayMock
    def send(opts)
      raise unless opts[:email] == 'test@localhost'
      raise unless opts[:locals][:user_email] == 'user@example.com'
      raise unless opts[:template_id] == 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy'
      raise unless opts[:reference] == 'notify_support_of_new_user'

      {}
    end
  end

  let(:new_user_email) { 'user@example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['notify_support_of_new_user']['template_id'] }

  subject do
    described_class.new(
      notifications_gateway: NotifySupportOfNewUserGatewayMock.new
    )
  end

  it 'calls notifications gateway with valid data' do
    expect {
      subject
        .execute(
          new_user_email: new_user_email,
          template_id: template_id
        )
    }.to_not raise_error
  end
end
