describe UseCases::Administrator::SendResetPasswordEmail do
  subject { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { spy(send: nil) }

  let(:email) { 'test@example.com' }
  let(:reset_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['reset_password_email']['template_id'] }

  before do
    subject.execute(
      email: email,
      reset_url: reset_url,
      template_id: template_id
    )
  end

  it 'calls notifications gateway with valid data' do
    expect(gateway_spy).to have_received(:send) do |args|
      expect(args[:email]).to eq(email)
      expect(args[:locals][:reset_url]).to eq(reset_url)
      expect(args[:template_id]).to eq(template_id)
      expect(args[:reference]).to eq('reset_password_email')
    end
  end
end
