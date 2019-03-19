describe UseCases::Administrator::SendInviteEmail do
  subject { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { spy(send: nil) }

  let(:email) { 'test@example.com' }
  let(:invite_url) { 'https://example.com' }
  let(:template_id) { GOV_NOTIFY_CONFIG['invite_email']['template_id'] }

  before do
    subject.execute(
      email: email,
      invite_url: invite_url,
      template_id: template_id
    )
  end

  it 'calls notifications gateway with valid data' do
    expect(gateway_spy).to have_received(:send) do |args|
      expect(args[:email]).to eq(email)
      expect(args.dig(:locals, :invite_url)).to eq(invite_url)
      expect(args[:template_id]).to eq(template_id)
      expect(args[:reference]).to eq('invite_email')
    end
  end
end
