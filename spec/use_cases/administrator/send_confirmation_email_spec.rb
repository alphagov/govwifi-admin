describe UseCases::Administrator::SendConfirmationEmail do
  subject(:use_case) { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { spy(send: nil) }

  let(:email) { 'test@example.com' }
  let(:confirmation_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['confirmation_email']['template_id'] }

  before do
    use_case.execute(
      email: email,
      confirmation_url: confirmation_url,
      template_id: template_id
    )
  end

  it 'calls notifications gateway with valid data' do
    expect(gateway_spy).to have_received(:send) do |args|
      expect(args[:email]).to eq(email)
      expect(args.dig(:locals, :confirmation_url)).to eq(confirmation_url)
      expect(args[:template_id]).to eq(template_id)
      expect(args[:reference]).to eq('confirmation_email')
    end
  end
end
